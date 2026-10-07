"""Check that domain code speaks the language defined in a glossary.

1. Every public class in a concept module (`--concepts`) has a `## <ClassName>` glossary section.
2. Identifiers in the checked directories (`--check`) do not use a term listed under "- Avoid:".

Whether a term is used with the right meaning cannot be checked mechanically; that part is a review step.

Example, run from the repository root as a pre-commit hook:

    python scripts/check_glossary.py --check 'src/*/domain' --check 'src/*/usecases' \
        --concepts 'src/*/domain/**/entities.py' --concepts 'src/*/domain/**/values.py'
"""

import argparse
import ast
import re
import sys
from collections.abc import Iterator
from dataclasses import dataclass
from pathlib import Path

_HEADING = re.compile(r"^## (?P<term>.+?)\s*$")
_AVOID = re.compile(r"^- Avoid:\s*(?P<terms>.+?)\s*$")
_WORD = re.compile(r"[A-Z]+(?=[A-Z][a-z0-9]|$)|[A-Z]?[a-z0-9]+|[A-Z]+")


@dataclass(frozen=True)
class Term:
    name: str
    avoid: tuple[tuple[str, ...], ...]

    @property
    def anchor(self) -> str:
        return re.sub(r"[^a-z0-9 -]", "", self.name.lower()).replace(" ", "-")

    @property
    def replacement(self) -> str:
        return "_".join(words(self.name))


def words(identifier: str) -> list[str]:
    """Split snake_case and CamelCase identifiers into lowercase words."""
    return [match.lower() for part in identifier.split("_") for match in _WORD.findall(part)]


def parse_glossary(text: str) -> list[Term]:
    terms: list[Term] = []
    name: str | None = None
    avoid: list[tuple[str, ...]] = []
    for line in text.splitlines():
        if heading := _HEADING.match(line):
            if name is not None:
                terms.append(Term(name, tuple(avoid)))
            name, avoid = heading["term"], []
        elif name is not None and (listed := _AVOID.match(line)):
            avoid.extend(tuple(words(term)) for term in listed["terms"].split(",") if words(term))
    if name is not None:
        terms.append(Term(name, tuple(avoid)))
    return terms


def identifiers(tree: ast.AST) -> Iterator[tuple[int, str]]:
    """Names this code introduces or refers to, with their line numbers."""
    for node in ast.walk(tree):
        match node:
            case ast.FunctionDef(name=name) | ast.AsyncFunctionDef(name=name) | ast.ClassDef(name=name):
                yield node.lineno, name
            case ast.Name(id=name) | ast.Attribute(attr=name) | ast.arg(arg=name):
                yield node.lineno, name
            case ast.alias(name=name, asname=asname):
                yield node.lineno, asname or name.rpartition(".")[2]
            case ast.keyword(arg=str() as name):
                yield node.lineno, name


def contains(sequence: list[str], sub: tuple[str, ...]) -> bool:
    return any(tuple(sequence[i : i + len(sub)]) == sub for i in range(len(sequence) - len(sub) + 1))


def avoided_terms(path: Path, terms: list[Term], glossary: Path) -> Iterator[str]:
    tree = ast.parse(path.read_text(encoding="utf-8"), filename=str(path))
    reported: set[tuple[int, str]] = set()
    for lineno, name in identifiers(tree):
        split = words(name)
        for term in terms:
            for avoided in term.avoid:
                if contains(split, avoided) and (lineno, " ".join(avoided)) not in reported:
                    reported.add((lineno, " ".join(avoided)))
                    yield (
                        f"{path}:{lineno}: `{'_'.join(avoided)}` is not a term in this codebase, "
                        f"use `{term.replacement}` (see {glossary}#{term.anchor})"
                    )


def missing_entries(path: Path, defined: set[str], glossary: Path) -> Iterator[str]:
    tree = ast.parse(path.read_text(encoding="utf-8"), filename=str(path))
    for node in tree.body:
        if isinstance(node, ast.ClassDef) and not node.name.startswith("_") and node.name not in defined:
            yield (
                f"{path}:{node.lineno}: `{node.name}` is a domain concept without a glossary entry; add a "
                f"`## {node.name}` section to {glossary} defining it, with `- Avoid:` synonyms if any"
            )


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--glossary", type=Path, default=Path("GLOSSARY.md"))
    parser.add_argument("--check", action="append", default=[], help="glob of directories checked for avoided terms")
    parser.add_argument("--concepts", action="append", default=[], help="glob of modules whose classes need entries")
    args = parser.parse_args()

    terms = parse_glossary(args.glossary.read_text(encoding="utf-8"))
    defined = {term.name for term in terms}
    errors: list[str] = []
    for pattern in args.check:
        for directory in sorted(Path().glob(pattern)):
            for path in sorted(directory.rglob("*.py")):
                errors.extend(avoided_terms(path, terms, args.glossary))
    for pattern in args.concepts:
        for path in sorted(Path().glob(pattern)):
            errors.extend(missing_entries(path, defined, args.glossary))
    for error in errors:
        print(error, file=sys.stderr)
    return 1 if errors else 0


if __name__ == "__main__":
    raise SystemExit(main())
