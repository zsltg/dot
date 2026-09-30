return {
	"stevearc/conform.nvim",
	event = "VeryLazy",
	dependencies = { "mason.nvim" },
	opts = {
		formatters_by_ft = {
			astro = { "prettierd", "prettier", stop_after_first = true },
			c = { "clang-format" },
			cpp = { "clang-format" },
			lua = { "stylua" },
			javascript = { "prettierd", "prettier", stop_after_first = true },
			typescript = { "prettierd", "prettier", stop_after_first = true },
		},
		default_format_opts = {
			lsp_format = "fallback",
		},
		format_after_save = {
			lsp_format = "fallback",
		},
		--		-- florianraith/neovim-config
		--		local priorities = {
		--			prettierd = 1000,
		--		}
		--		local function contains(array, value)
		--			for _, v in ipairs(array) do
		--				if v == value then
		--					return true
		--				end
		--			end
		--			return false
		--		end
		--		-- inject the formatters installed through mason into conform
		--		local packages = require("mason-registry").get_installed_packages()
		--		local formatters_by_ft = {}
		--		for _, package in ipairs(packages) do
		--			if contains(package.spec.categories, "Formatter") then
		--				for _, lang in ipairs(package.spec.languages) do
		--					local lang_lower = string.lower(lang)
		--					if not formatters_by_ft[lang_lower] then
		--						formatters_by_ft[lang_lower] = {}
		--					end
		--
		--					table.insert(formatters_by_ft[lang_lower], package.name)
		--				end
		--			end
		--		end
		--		-- sort each list by our priorities (default 0), highest first
		--		for _, list in pairs(formatters_by_ft) do
		--			table.sort(list, function(a, b)
		--				local pa = priorities[a] or 0
		--				local pb = priorities[b] or 0
		--				return pa > pb
		--			end)
		--			-- if there's more than one, stop on the first
		--			if #list > 1 then
		--				list.stop_after_first = true
		--			end
		--		end
		--		local opts = {
		--			formatters_by_ft = formatters_by_ft,
		--			default_format_opts = {
		--				lsp_format = "fallback",
		--			},
		--			format_after_save = {
		--				lsp_format = "fallback",
		--			},
		--		}
		--		return opts
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
