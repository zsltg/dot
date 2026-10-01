return {
	-- Git hunks in the sign column, hunk actions and blame.
	"lewis6991/gitsigns.nvim",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		-- Color the line numbers, not the sign column, so that the text does
		-- not move when a hunk shows. mini.diff did the same.
		signcolumn = false,
		numhl = true,
		on_attach = function(bufnr)
			local gitsigns = require("gitsigns")
			local function map(mode, lhs, rhs, desc)
				vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
			end
			map("n", "]h", function()
				gitsigns.nav_hunk("next")
			end, "Next hunk")
			map("n", "[h", function()
				gitsigns.nav_hunk("prev")
			end, "Previous hunk")
			map("n", "<leader>hs", gitsigns.stage_hunk, "Stage hunk")
			map("n", "<leader>hr", gitsigns.reset_hunk, "Reset hunk")
			map("n", "<leader>hp", gitsigns.preview_hunk, "Preview hunk")
			map("n", "<leader>hb", gitsigns.blame_line, "Blame line")
			map({ "o", "x" }, "ih", gitsigns.select_hunk, "Select hunk")
		end,
	},
}
