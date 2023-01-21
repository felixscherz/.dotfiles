local neotest = require("neotest")

vim.keymap.set("n", "<leader>nto", neotest.summary.open)
vim.keymap.set("n", "<leader>ntp", neotest.output_panel.open)

vim.keymap.set("n", "<leader>ntr", neotest.run.run)
vim.keymap.set("n", "<leader>ntf", function() neotest.run.run(vim.fn.expand("%")) end)
vim.keymap.set("n", "<leader>nts", neotest.run.stop)
vim.keymap.set("n", "<leader>nta", neotest.run.attach)



