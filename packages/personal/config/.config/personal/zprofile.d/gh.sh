# Go to the worktree that has a PR's branch checked out, or check the PR out here.
# Avoids "already checked out at ..." errors when an agent's worktree holds the branch.
prco() {
  local branch wt
  branch=$(gh pr view "$1" --json headRefName -q .headRefName) || return
  wt=$(git worktree list --porcelain | awk -v b="refs/heads/$branch" \
    '/^worktree /{p=substr($0,10)} $0=="branch "b{print p}')
  if [[ -n $wt ]]; then cd "$wt"; else gh pr checkout "$1"; fi
}
