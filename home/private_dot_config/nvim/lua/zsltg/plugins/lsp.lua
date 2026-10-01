return {
	{
		"mason-org/mason.nvim",
		opts = {
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		},
	},
	{
		-- Enables each language server that Mason installed.
		"mason-org/mason-lspconfig.nvim",
		dependencies = {
			"mason-org/mason.nvim",
			"neovim/nvim-lspconfig",
		},
		opts = {
			automatic_enable = {
				-- conform.nvim runs stylua.
				exclude = { "stylua" },
			},
		},
	},
	{
		-- Installs the language servers, linters and formatters.
		-- Language servers use the nvim-lspconfig names.
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "mason-org/mason-lspconfig.nvim" },
		opts = {
			ensure_installed = {
				-- Language servers
				"astro", -- Astro
				"autotools_ls", -- Makefile, Autotools
				"basedpyright", -- Python types
				"bashls", -- sh, bash
				"clangd", -- C, C++
				"cssls", -- CSS
				"docker_language_server", -- Dockerfile, Compose
				"gopls", -- Go
				"jdtls", -- Java
				"jsonls", -- JSON
				"kotlin_lsp", -- Kotlin
				"lemminx", -- XML (also formats)
				"lua_ls", -- Lua
				"marksman", -- Markdown
				"perlnavigator", -- Perl
				"ruff", -- Python lint and format
				"rust_analyzer", -- Rust
				"sqls", -- SQL
				"superhtml", -- HTML
				"tailwindcss", -- Tailwind CSS
				"taplo", -- TOML
				"unocss", -- UnoCSS
				"vtsls", -- JavaScript, TypeScript
				"yamlls", -- YAML
				-- Linters
				"actionlint", -- GitHub Actions
				"checkmake", -- Makefile
				"eslint_d", -- JavaScript, TypeScript
				"golangci-lint", -- Go
				"hadolint", -- Dockerfile
				"ktlint", -- Kotlin (also formats)
				"luacheck", -- Lua
				"markdownlint-cli2", -- Markdown
				"shellcheck", -- sh, bash (bashls uses it)
				"sqlfluff", -- SQL
				-- Formatters
				"goimports", -- Go
				"google-java-format", -- Java
				"prettierd", -- JavaScript, TypeScript, HTML, CSS, JSON, YAML, Markdown
				"shfmt", -- sh, bash
				"sql-formatter", -- SQL
				"stylua", -- Lua
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"saghen/blink.cmp",
			"b0o/SchemaStore.nvim",
		},
		config = function()
			-- Keymaps for each buffer that has a language server.
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("zsltg_lsp", { clear = true }),
				callback = function(args)
					local bufmap = function(mode, lhs, rhs, desc)
						vim.keymap.set(mode, lhs, rhs, { buffer = args.buf, desc = desc })
					end
					bufmap("n", "gd", vim.lsp.buf.definition, "Go to Definition")
					bufmap("n", "gD", vim.lsp.buf.declaration, "Go to Declaration")
					bufmap("n", "gr", vim.lsp.buf.references, "List References")
					bufmap("n", "gi", vim.lsp.buf.implementation, "Go to Implementation")
					bufmap("n", "K", vim.lsp.buf.hover, "Hover Documentation")
				end,
			})
			-- The settings that follow add to the nvim-lspconfig defaults.
			-- lazydev.nvim adds the Neovim runtime to the workspace.
			vim.lsp.config("lua_ls", {
				settings = {
					Lua = {
						runtime = { version = "LuaJIT" },
						telemetry = { enable = false },
					},
				},
			})
			-- Ruby. mise installs rubocop and solargraph (dev group), not Mason.
			-- The rubocop server gives the diagnostics and formatting.
			-- Enable them only when they are installed.
			for _, server in ipairs({ "rubocop", "solargraph" }) do
				if vim.fn.executable(server) == 1 then
					vim.lsp.enable(server)
				end
			end
			vim.lsp.config("solargraph", {
				settings = {
					solargraph = {
						diagnostics = false,
						formatting = false,
					},
				},
			})
			vim.lsp.config("clangd", {
				cmd = {
					"clangd",
					"--background-index",
					"--clang-tidy",
					"--completion-style=detailed",
					"--header-insertion=iwyu",
				},
			})
			-- Mason installs the JetBrains server as intellij-server.
			vim.lsp.config("kotlin_lsp", {
				cmd = { "intellij-server", "--stdio" },
				-- RocksDB loads its musl library when musl is installed, but the
				-- package has only the glibc library.
				cmd_env = { ROCKSDB_MUSL_LIBC = "false" },
			})
			-- sqls shows a message for each file when its configuration has no
			-- database connection. Completion of the SQL keywords works without one.
			vim.lsp.config("sqls", {
				handlers = {
					["window/showMessage"] = function(err, result, ctx)
						if result and result.message:find("no database connection", 1, true) then
							return
						end
						return vim.lsp.handlers["window/showMessage"](err, result, ctx)
					end,
				},
			})
			vim.lsp.config("jsonls", {
				settings = {
					json = {
						schemas = require("schemastore").json.schemas(),
						validate = { enable = true },
					},
				},
			})
			vim.lsp.config("yamlls", {
				settings = {
					yaml = {
						-- Use the SchemaStore.nvim catalog, not the download.
						schemaStore = { enable = false, url = "" },
						schemas = require("schemastore").yaml.schemas(),
					},
				},
			})
		end,
	},
	{
		"b0o/SchemaStore.nvim",
		lazy = true,
	},
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				{
					path = "${3rd}/luv/library",
					words = { "vim%.uv" },
				},
			},
		},
	},
}
