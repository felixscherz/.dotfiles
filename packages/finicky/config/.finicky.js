// ~/.finicky.js
export default {
  defaultBrowser: "Brave Browser",
  handlers: [
    {
      // anything with exxeta-it.com -> exxeta profile
      match: finicky.matchHostnames(["exxeta-it.com", "*.exxeta-it.com"]),
      browser: "Brave Browser:exxeta",
    },
    {
      // mercedes-benz.ghe.com -> mercedes-v2 profile
      match: "mercedes-benz.ghe.com/*",
      browser: "Brave Browser:mercedes-v2",
    },
    {
      // vds-jira -> mercedes-v2 profile
      match: "vds-jira.dot.i.mercedes-benz.com/*",
      browser: "Brave Browser:mercedes-v2",
    },
    {
      // atlassian jira -> mercedes-mcp-jira profile
      match: "mercedes-benz.atlassian.net/*",
      browser: "Brave Browser:mercedes-mcp-jira",
    },
    {
      match:
        "https://eur01.safelinks.protection.outlook.com/?url=https%3A%2F%2Fmercedes-benz.atlassian.net%2F*",
      browser: "Brave Browser:mercedes-mcp-jira",
    },
    {
      match:
        "https://teams.public.onecdn.static.microsoft/evergreen-assets/safelinks/2/atp-safelinks.html?url=https%3A%2F%2Fvds-jira.dot.i.mercedes-benz.com%2*",
      browser: "Brave Browser:mercedes-v2",
    },
    {
      match:
        "https://login.microsoftonline.com/338159a0-dd8f-45af-9672-faaa54bc6b24/*",
      browser: "Brave Browser:exxeta",
    },
    {
      match: "https://d050alrct167.de050.corpintra.net/*",
      browser: "Brave Browser:mercedes-v2",
    },
    {
      match: "https://teams.public.onecdn.static.microsoft/evergreen-assets/safelinks/2/atp-safelinks.html?url=https%3A%2F%2Fd050alrct167.de050.corpintra.net%2F*",
      browser: "Brave Browser:mercedes-v2",
    },
    {
       match:"https://teams.public.onecdn.static.microsoft/evergreen-assets/safelinks/2/atp-safelinks.html?url=https%3A%2F%2Fvds-central.de050.corpintra.net%2*",
       browser: "Brave Browser:mercedes-v2",
     },
    {
      match: "https://teams.public.onecdn.static.microsoft/evergreen-assets/safelinks/2/atp-safelinks.html?url=https%3A%2F%2Fmercedes-benz.atlassian.net%2F*",
      browser: "Brave Browser:mercedes-mcp-jira",
    },
    {
      match: "https://oidc.eu-central-1.amazonaws.com/authorize?response_type=code&client_id=dYypnqbqyGAWrEYT7KR2WGV1LWNlbnRyYWwtMQ&*",
      browser: "Brave Browser:mercedes-v2",
    },
    {
      match: "https://*de050.corpintra.net*",
      browser: "Brave Browser:mercedes-v2",
    }
   ],
 };
