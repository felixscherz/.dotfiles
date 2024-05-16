return {
	"mfussenegger/nvim-dap",
	event = "BufReadPre",
	dependencies = {
		"theHamsta/nvim-dap-virtual-text",
		"rcarriga/nvim-dap-ui",
		"mfussenegger/nvim-dap-python",
		"nvim-telescope/telescope-dap.nvim",
		{ "leoluz/nvim-dap-go", module = "dap-go" },
		{ "jbyuki/one-small-step-for-vimkind", module = "osv" },
		{ "nvim-neotest/nvim-nio", commit = "7fa5545299fc7a48d5ec74d27f414b862060095f" },
	},
	config = function()
		require("custom.ide.dap.dap").setup()
	end,
}
