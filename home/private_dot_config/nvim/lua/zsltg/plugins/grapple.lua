return {
	-- Tag files and jump to them by index. One tag list per Git repository.
	"cbochs/grapple.nvim",
	cmd = "Grapple",
	opts = {
		scope = "git",
	},
	keys = {
		{ "<leader>a", "<cmd>Grapple toggle<cr>", desc = "Grapple tag file" },
		{ "<C-e>", "<cmd>Grapple toggle_tags<cr>", desc = "Grapple tag list" },
		{ "<C-h>", "<cmd>Grapple select index=1<cr>", desc = "Grapple go to tag 1" },
		{ "<C-j>", "<cmd>Grapple select index=2<cr>", desc = "Grapple go to tag 2" },
		{ "<C-k>", "<cmd>Grapple select index=3<cr>", desc = "Grapple go to tag 3" },
		{ "<C-l>", "<cmd>Grapple select index=4<cr>", desc = "Grapple go to tag 4" },
	},
}
