return {
	{
		-- The main branch needs Neovim 0.12 and the tree-sitter CLI to build parsers.
		-- The master branch is frozen and does not work with Neovim 0.12.
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			local treesitter = require("nvim-treesitter")
			-- Parsers to always install. The function does nothing for installed parsers.
			treesitter.install({
				"astro",
				"bash",
				"c",
				"cpp",
				"css",
				"dockerfile",
				"go",
				"html",
				"java",
				"javascript",
				"json",
				"kotlin",
				"lua",
				"make",
				"markdown",
				"markdown_inline",
				"perl",
				"python",
				"query",
				"ruby",
				"rust",
				"toml",
				"tsx",
				"typescript",
				"vim",
				"vimdoc",
				"yaml",
			})
			-- Start tree-sitter highlighting for each file type that has a parser.
			-- Install a missing parser first, if nvim-treesitter has it.
			local available = {}
			for _, lang in ipairs(treesitter.get_available()) do
				available[lang] = true
			end
			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("zsltg_treesitter", { clear = true }),
				callback = function(args)
					local lang = vim.treesitter.language.get_lang(args.match)
					if not lang or not available[lang] then
						return
					end
					local function start()
						if vim.api.nvim_buf_is_valid(args.buf) then
							pcall(vim.treesitter.start, args.buf, lang)
						end
					end
					if vim.list_contains(treesitter.get_installed("parsers"), lang) then
						start()
					else
						treesitter.install(lang):await(function(err)
							if not err then
								vim.schedule(start)
							end
						end)
					end
				end,
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
