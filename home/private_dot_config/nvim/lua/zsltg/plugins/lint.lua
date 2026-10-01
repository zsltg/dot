-- Linters for file types that have no language server diagnostics.
-- The language servers give diagnostics for the other file types.
local eslint = { "eslint_d" }

return {
	"mfussenegger/nvim-lint",
	opts = {
		events = { "BufWritePost", "BufReadPost", "InsertLeave" },
		linters_by_ft = {
			dockerfile = { "hadolint" },
			go = { "golangcilint" },
			javascript = eslint,
			javascriptreact = eslint,
			kotlin = { "ktlint" },
			lua = { "luacheck" },
			make = { "checkmake" },
			markdown = { "markdownlint-cli2" },
			sql = { "sqlfluff" },
			typescript = eslint,
			typescriptreact = eslint,
			yaml = { "actionlint" },
		},
		-- Run a linter only when its condition is true.
		conditions = {
			-- eslint gives an error when the project has no eslint configuration.
			eslint_d = function(ctx)
				return vim.fs.find(function(name)
					return name:match("^eslint%.config%.") or name:match("^%.eslintrc")
				end, { path = ctx.dirname, upward = true })[1] ~= nil
			end,
			-- sqlfluff needs the SQL dialect from the project configuration.
			sqlfluff = function(ctx)
				return vim.fs.find(".sqlfluff", { path = ctx.dirname, upward = true })[1] ~= nil
			end,
			-- actionlint is for GitHub Actions workflows only.
			actionlint = function(ctx)
				return ctx.filename:find("/%.github/workflows/") ~= nil
			end,
		},
	},
	config = function(_, opts)
		local M = {}
		local lint = require("lint")
		lint.linters_by_ft = opts.linters_by_ft
		for name, condition in pairs(opts.conditions) do
			lint.linters[name].condition = condition
		end
		-- Use the dialect from .sqlfluff, not the nvim-lint default (ansi).
		lint.linters.sqlfluff.args = vim.tbl_filter(function(arg)
			return not arg:match("^%-%-dialect=")
		end, lint.linters.sqlfluff.args)
		function M.debounce(ms, fn)
			local timer = vim.uv.new_timer()
			return function(...)
				local argv = { ... }
				timer:start(ms, 0, function()
					timer:stop()
					vim.schedule_wrap(fn)(unpack(argv))
				end)
			end
		end
		function M.lint()
			-- Use nvim-lint's logic first:
			-- * checks if linters exist for the full filetype first
			-- * otherwise will split filetype by "." and add all those linters
			-- * this differs from conform.nvim which only uses the first
			--   filetype that has a formatter
			local names = lint._resolve_linter_by_ft(vim.bo.filetype)
			-- Create a copy of the names table to avoid modifying the
			-- original.
			names = vim.list_extend({}, names)
			-- Add fallback linters.
			if #names == 0 then
				vim.list_extend(names, lint.linters_by_ft["_"] or {})
			end
			-- Add global linters.
			vim.list_extend(names, lint.linters_by_ft["*"] or {})
			-- Filter out linters that don't exist or don't match the
			-- condition.
			local ctx = { filename = vim.api.nvim_buf_get_name(0) }
			ctx.dirname = vim.fn.fnamemodify(ctx.filename, ":h")
			names = vim.tbl_filter(function(name)
				local linter = lint.linters[name]
				if not linter then
					vim.api.nvim_echo({ { "Linter not found: " .. name, "WarningMsg" } }, true, {})
				end
				return linter and not (type(linter) == "table" and linter.condition and not linter.condition(ctx))
			end, names)
			-- Run linters.
			if #names > 0 then
				lint.try_lint(names)
			end
		end
		vim.api.nvim_create_autocmd(opts.events, {
			group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
			callback = M.debounce(100, M.lint),
		})
	end,
}
