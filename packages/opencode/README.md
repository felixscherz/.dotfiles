# opencode

`config/` is linked to `~/.config/opencode`.

## LiteLLM providers

`config/opencode.json` loads `opencode-plugin-litellm`. The plugin reads
`/v1/models` from a LiteLLM proxy and registers every model it finds, so
providers like `exxeta` need no `models` block.

The plugin only picks up a provider if its ID is `litellm`, starts with
`litellm-` or `litellm_`, or has `"litellm": true` in `settings`. `exxeta` uses
the flag.

### API key

The key has to be set on the provider itself:

```json
"apiKey": "{env:EXXETA_LITELLM_API_KEY}"
```

A key saved with `opencode auth login` does not work here. OpenCode only links
a provider to its stored credential when the provider is in the models.dev
catalog, and `exxeta` is not. Without the link the plugin fetches the model
list without a key, the proxy answers 401, and the model picker stays empty.

The plugin runs inside the background service, so the variable has to be in
the service's environment. Set it once with:

```sh
opencode service set env EXXETA_LITELLM_API_KEY <key>
opencode service restart
```

OpenCode stores it in the service config and applies it on every start.
`opencode service get env` shows what is set. `launchctl setenv` or a shell
export is not reliable, because the service is not a launchd job and inherits
the environment of whichever `opencode` command starts it first.

### Debugging

- OpenCode only reads `.opencode/` in the git root of the project, plus
  `~/.config/opencode` and `~/.opencode`. A config in a parent folder such as
  `~/workspaces/.opencode` is ignored.
- Use the v2 keys `providers`, `package` and `settings`. The v1 keys
  `provider`, `npm` and `options` are ignored by the plugin's v2 code path.
- Check what the service sees with
  `curl -u opencode:<password> http://127.0.0.1:<port>/api/provider`. The URL
  and password are in `~/.local/state/opencode/service.json`.
