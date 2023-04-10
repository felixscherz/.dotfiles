return {
	settings = {
		yaml = {
			schemaStore = {
				enable = true,
                url = "https://www.schemastore.org/api/json/catalog.json"
			},
			customTags = {
				"!Base64 scalar",
				"!Cidr scalar",
				"!And sequence",
				"!Equals sequence",
				"!If sequence",
				"!Not sequence",
				"!Or sequence",
				"!Condition scalar",
				"!FindInMap sequence",
				"!GetAtt scalar",
				"!GetAtt sequence",
				"!GetAZs scalar",
				"!ImportValue scalar",
				"!Join sequence",
				"!Select sequence",
				"!Split sequence",
				"!Sub scalar",
				"!Transform mapping",
				"!Ref scalar",
			},
			hover = true,
			validate = true,
		},
	},
}
