return {
	settings = {
		yaml = {
			schemaStore = {
				enable = false,
				url = "",
			},
			schemas = require("schemastore").yaml.schemas(),
			hover = true,
			validate = true,
			completion = true,
		},
	},
}
