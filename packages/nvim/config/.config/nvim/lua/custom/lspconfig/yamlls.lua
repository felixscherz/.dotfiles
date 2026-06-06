---
---
local schemastore_schemas = require("schemastore").yaml.schemas()
local schema_overrides = {
	["https://raw.githubusercontent.com/asyncapi/spec-json-schemas/refs/heads/master/schemas/2.0.0.json"] = "asyncapi.yaml",
	["https://raw.githubusercontent.com/asyncapi/spec-json-schemas/refs/heads/master/schemas/2.1.0.json"] = "asyncapi.yaml",
	["https://raw.githubusercontent.com/asyncapi/spec-json-schemas/refs/heads/master/schemas/2.2.0.json"] = "asyncapi.yaml",
	["https://raw.githubusercontent.com/asyncapi/spec-json-schemas/refs/heads/master/schemas/2.3.0.json"] = "asyncapi.yaml",
	["https://raw.githubusercontent.com/asyncapi/spec-json-schemas/refs/heads/master/schemas/2.4.0.json"] = "asyncapi.yaml",
	["https://raw.githubusercontent.com/asyncapi/spec-json-schemas/refs/heads/master/schemas/2.5.0.json"] = "asyncapi.yaml",
	["https://raw.githubusercontent.com/asyncapi/spec-json-schemas/refs/heads/master/schemas/2.6.0.json"] = "asyncapi.yaml",
	["https://raw.githubusercontent.com/asyncapi/spec-json-schemas/refs/heads/master/schemas/3.0.0.json"] = "asyncapi.yaml",
}

---@type vim.lsp.Config
return {
	settings = {
		yaml = {
			schemaStore = {
				enable = false,
				url = "",
			},
			schemas = vim.tbl_extend("force", schemastore_schemas, schema_overrides),
			hover = true,
			validate = true,
			completion = true,
		},
	},
}
