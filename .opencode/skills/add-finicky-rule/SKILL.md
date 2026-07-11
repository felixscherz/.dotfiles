---
name: add-finicky-rule
description: Use ONLY when adding a new URL routing rule to @packages/finicky/config/.finicky.js. The user provides a URL and target browser profile; the agent should intelligently match on the domain/path pattern (not the full URL), leveraging Finicky's pattern matching and the existing rule examples.
---

# Adding Finicky Rules

When a user provides a URL and wants it routed to a specific Brave Browser profile, add a new handler rule to `.finicky.js`.

## Key Patterns

Finicky rules in the config use several matching patterns:

1. **Domain/hostname matching** (simple):
   ```js
   match: finicky.matchHostnames(["exxeta-it.com", "*.exxeta-it.com"]),
   ```

2. **URL path matching** (glob-style):
   ```js
   match: "mercedes-benz.ghe.com/*",
   ```

3. **Full URL prefix matching** (for complex URLs with query params):
   ```js
   match: "https://teams.public.onecdn.static.microsoft/evergreen-assets/safelinks/2/atp-safelinks.html?url=https%3A%2F%2Fvds-jira.dot.i.mercedes-benz.com%2*",
   ```

## Important Rules

- **Do not match the full URL.** URLs often contain encoded query parameters, session IDs, or other volatile data. Match only the stable prefix.
- **For Microsoft Teams SafeLinks**, the pattern is: `https://teams.public.onecdn.static.microsoft/evergreen-assets/safelinks/2/atp-safelinks.html?url=<encoded-target>*`
  - The `url=` parameter contains the actual destination URL (URL-encoded).
  - Extract the base domain/path from the encoded URL and use that in the pattern.
- **For Outlook SafeLinks**, the pattern is: `https://eur01.safelinks.protection.outlook.com/?url=<encoded-target>*`
- **Use `*` as a wildcard** at the end to match any query parameters, fragments, or additional path segments.

## Example Workflow

Given the URL in the user's message:
```
https://teams.public.onecdn.static.microsoft/evergreen-assets/safelinks/2/atp-safelinks.html?url=https%3A%2F%2Fvds-central.de050.corpintra.net%2Fmoca%2F...
```

1. Identify that it's a Teams SafeLinks wrapper.
2. Decode the `url=` parameter to find the target: `https://vds-central.de050.corpintra.net/moca/...`
3. Extract the stable base: `vds-central.de050.corpintra.net`
4. Add a rule that matches the SafeLinks pattern with the encoded target prefix:
   ```js
   {
     match: "https://teams.public.onecdn.static.microsoft/evergreen-assets/safelinks/2/atp-safelinks.html?url=https%3A%2F%2Fvds-central.de050.corpintra.net%2F*",
     browser: "Brave Browser:<profile>",
   }
   ```

## File Location

The Finicky config is at: `@packages/finicky/config/.finicky.js`

Add the new rule to the `handlers` array, placing it in a logical position (e.g., grouped with similar services or domains).
