return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "master",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			local treesitter = require("nvim-treesitter.configs")
			treesitter.setup({
				-- List of parsers to always install
				ensure_installed = {
					"astro",
					"c",
					"html",
					"javascript",
					"lua",
					"markdown",
					"markdown_inline",
					"query",
					"typescript",
					"vim",
					"vimdoc",
				},
				ignore_install = {},
				modules = treesitter.modules,
				-- Install ensure_installed synchronously
				sync_install = false,
				-- Automatically install missing parsers
				auto_install = true,
				highlight = {
					enable = true,
					-- Run `:h syntax` and tree-sitter at the same time.
					additional_vim_regex_highlighting = false,
				},
			})
		end,
	},
	{
		"windwp/nvim-ts-autotag",
		event = "VeryLazy",
		config = function()
			require("nvim-ts-autotag").setup({
				opts = {
					-- Auto close tags
					enable_close = true,
					-- Auto rename pairs of tags
					enable_rename = true,
					-- Auto close on trailing </
					enable_close_on_slash = false,
				},
				-- Override individual filetype configs
				per_filetype = {
					["html"] = {
						enable_close = false,
					},
				},
			})
		end,
	},
}
