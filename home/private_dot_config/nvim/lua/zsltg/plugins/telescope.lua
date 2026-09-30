return {
	"nvim-telescope/telescope.nvim",
	-- Latest release. 0.1.x needs the frozen master branch of nvim-treesitter.
	version = "*",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local telescope = require("telescope")
		telescope.setup({
			defaults = {
				vimgrep_arguments = {
					"rg",
					"--color=never",
					"--no-heading",
					"--with-filename",
					"--line-number",
					"--column",
					"--smart-case",
					"--hidden",
					"--glob=!.git/*",
				},
			},
			pickers = {
				find_files = {
					hidden = true,
					no_ignore = false,
				},
				live_grep = {
					additional_args = function()
						return { "--hidden", "--glob", "!.git/*" }
					end,
				},
			},
		})
		local builtin = require("telescope.builtin")
		vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
		vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
		vim.keymap.set("n", "<leader>fr", builtin.git_files, { desc = "Telescope find files in a Git repository" })
	end,
}
