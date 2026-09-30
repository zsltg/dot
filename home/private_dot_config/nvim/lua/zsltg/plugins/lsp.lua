return {
	{
		"mason-org/mason-lspconfig.nvim",
		opts = {
			ensure_installed = {
				"astro", -- Astro
				"clangd", -- C, CPP
				"lua_ls", -- Lua
				"solargraph", -- Ruby
				"superhtml", -- HTML
				"tailwindcss", -- Tailwind CSS
				"vtsls", -- TypeScript
			},
		},
		dependencies = {
			"mason-org/mason.nvim",
			"neovim/nvim-lspconfig",
		},
	},
	{
		"mason-org/mason.nvim",
		opts = {
			ensure_installed = {
				"autotools-language-server", -- Makefile
				"checkmake", -- Makefile
				"eslint_d", -- JavaScript, TypeScript
				"luacheck", -- Lua
				"prettier", -- JavaScript, TypeScript, ...
				"prettierd", -- JavaScript, TypeScript, ...
				"stylua", -- Lua
				"unocss-language-server", -- UnoCSS
			},
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
		"neovim/nvim-lspconfig",
		dependencies = {
			"saghen/blink.cmp",
			"folke/lazydev.nvim",
			--"WhoIsSethDaniel/mason-tool-installer.nvim",
		},
		config = function()
			local on_attach = function(_, bufnr)
				local bufmap = function(mode, lhs, rhs, desc)
					vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
				end
				-- LSP keymaps
				bufmap("n", "gd", vim.lsp.buf.definition, "Go to Definition")
				bufmap("n", "gD", vim.lsp.buf.declaration, "Go to Declaration")
				bufmap("n", "gr", vim.lsp.buf.references, "List References")
				bufmap("n", "gi", vim.lsp.buf.implementation, "Go to Implementation")
				bufmap("n", "K", vim.lsp.buf.hover, "Hover Documentation")
			end
			-- Lua
			vim.lsp.config["lua_ls"] = {
				settings = {
					Lua = {
						runtime = {
							version = "LuaJIT",
						},
						diagnostics = {
							globals = { "vim" },
						},
						workspace = {
							library = vim.api.nvim_get_runtime_file("", true),
							checkThirdParty = false,
						},
						--completion = {
						--    callSnippet = "Replace",
						--},
						telemetry = { enable = false },
					},
				},
				on_attach = on_attach,
			}
			vim.lsp.enable("lua_ls")
			-- Ruby
			vim.lsp.config["solargraph"] = {
				settings = {
					solargraph = {
						diagnostics = true,
						formatting = true,
					},
				},
				root_markers = { "Gemfile", ".git" },
				on_attach = on_attach,
			}
			vim.lsp.enable("solargraph")
			-- JavaScript/TypeScript
			vim.lsp.config["vtsls"] = {
				filetypes = {
					"javascript",
					"javascriptreact",
					"typescript",
					"typescriptreact",
					"astro",
				},
				root_markers = { "package.json", "tsconfig.json", ".git" },
				on_attach = on_attach,
			}
			vim.lsp.enable("vtsls")
			-- Astro
			vim.lsp.config["astro"] = {
				filetypes = { "astro" },
				root_markers = { "astro.config.mjs", ".git" },
				on_attach = on_attach,
			}
			vim.lsp.enable("astro")
			-- HTML
			vim.lsp.config["superhtml"] = {
				cmd = { "superhtml", "lsp" },
				filetypes = { "html", "shtml", "htm" },
				root_markers = { ".git" },
				on_attach = on_attach,
			}
			vim.lsp.enable("superhtml")
			-- Tailwind CSS
			vim.lsp.config["tailwindcss"] = {
				cmd = { "tailwindcss-language-server", "--stdio" },
				filetypes = {
					"html",
					"css",
					"scss",
					"javascript",
					"javascriptreact",
					"typescript",
					"typescriptreact",
					"vue",
					"svelte",
					"astro",
				},
				root_dir = require("lspconfig.util").root_pattern(
					"tailwind.config.js",
					"tailwind.config.cjs",
					"tailwind.config.mjs",
					"tailwind.config.ts",
					"postcss.config.js",
					"package.json",
					".git"
				),
				settings = {
					tailwindCSS = {
						includeLanguages = {
							astro = "html",
						},
						experimental = {
							classRegex = {},
						},
					},
				},
				on_attach = on_attach,
			}
			vim.lsp.enable("tailwindcss")
			-- UnoCSS
			vim.lsp.config["unocss"] = {
				name = "unocss",
				cmd = { "unocss-language-server", "--stdio" },
				filetypes = {
					"html",
					"javascript",
					"javascriptreact",
					"typescript",
					"typescriptreact",
					"vue",
					"svelte",
					"astro",
				},
				root_markers = {
					"unocss.config.ts",
					"unocss.config.js",
					"package.json",
					".git",
				},
			}
			vim.lsp.enable("unocss")
			-- GNU Autotools
			vim.lsp.config["autotools_ls"] = {
				cmd = { "autotools-language-server" },
				filetypes = { "automake", "config", "make" },
				root_markers = {
					"*.mk",
					"Makefile",
					"Makefile.am",
					"configure.ac",
				},
			}
			vim.lsp.enable("autotools_ls")
			-- C, CPP
			vim.lsp.config["clangd"] = {
				cmd = {
					"clangd",
					"--background-index",
					"--clang-tidy",
					"--completion-style=detailed",
					"--header-insertion=iwyu",
				},
			}
			vim.lsp.enable("clangd")
		end,
	},
	{
		"folke/lazydev.nvim",
		opts = {
			library = {
				{
					path = "${3rd}/luv/library",
					words = { "vim%.uv" },
				},
			},
		},
	},
	--{
	--	"WhoIsSethDaniel/mason-tool-installer.nvim",
	--	config = function()
	--		local servers = {
	--			"astro",
	--			"lua_ls",
	--			"solargraph",
	--			"superhtml",
	--			"tailwindcss",
	--			"vtsls",
	--		}
	--		local ensure_installed = servers
	--		vim.list_extend(ensure_installed, {
	--			"eslint_d",
	--			"luacheck",
	--			"prettierd",
	--			"stylua",
	--			"unocss-language-server",
	--		})
	--		require("mason-tool-installer").setup({
	--			ensure_installed = ensure_installed,
	--		})
	--	end,
	--},
}
