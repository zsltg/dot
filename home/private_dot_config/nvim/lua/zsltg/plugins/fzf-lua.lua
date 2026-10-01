return {
	-- Fuzzy finder. It uses the fzf, fd and rg commands.
	"ibhagwan/fzf-lua",
	cmd = "FzfLua",
	opts = {
		-- fd and rg skip .git and the files in .gitignore.
		files = { hidden = true },
		grep = { hidden = true },
	},
	init = function()
		-- Use fzf-lua for vim.ui.select, for example the code action menu.
		vim.ui.select = function(...)
			require("fzf-lua").register_ui_select()
			return vim.ui.select(...)
		end
	end,
	keys = {
		{ "<leader>ff", "<cmd>FzfLua files<cr>", desc = "Find files" },
		{ "<leader>fg", "<cmd>FzfLua live_grep<cr>", desc = "Live grep" },
		{ "<leader>fr", "<cmd>FzfLua git_files<cr>", desc = "Find files in the Git repository" },
	},
}
