local prettier = { "prettierd" }

return {
	"stevearc/conform.nvim",
	event = "VeryLazy",
	-- File types not in the list use the language server to format:
	-- C, C++ (clangd), Ruby (rubocop), Perl (perlnavigator), XML (lemminx).
	opts = {
		formatters_by_ft = {
			astro = prettier,
			bash = { "shfmt" },
			css = prettier,
			go = { "goimports", "gofmt" },
			html = prettier,
			java = { "google-java-format" },
			javascript = prettier,
			javascriptreact = prettier,
			json = prettier,
			jsonc = prettier,
			kotlin = { "ktlint" },
			lua = { "stylua" },
			markdown = prettier,
			python = { "ruff_organize_imports", "ruff_format" },
			rust = { "rustfmt" },
			scss = prettier,
			sh = { "shfmt" },
			sql = { "sql_formatter" },
			toml = { "taplo" },
			typescript = prettier,
			typescriptreact = prettier,
			yaml = prettier,
		},
		default_format_opts = {
			lsp_format = "fallback",
		},
		format_after_save = {
			lsp_format = "fallback",
		},
	},
	keys = {
		{
			"<leader>cf",
			function()
				require("conform").format({ async = false })
			end,
			desc = "Format file",
		},
	},
}
