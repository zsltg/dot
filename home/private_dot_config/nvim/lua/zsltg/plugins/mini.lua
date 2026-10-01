return {
	"nvim-mini/mini.nvim",
	enabled = true,
	config = function()
		require("mini.icons").setup()
		-- Plugins that use nvim-web-devicons get the mini.icons icons.
		require("mini.icons").mock_nvim_web_devicons()
		require("mini.git").setup()
		require("mini.diff").setup()
		require("mini.statusline").setup({ use_icons = true })
		require("mini.pairs").setup({
			modes = { insert = true, command = true, terminal = false },
			-- skip autopair when next character is one of these
			skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
			-- skip autopair when the cursor is inside these treesitter nodes
			skip_ts = { "string" },
			-- skip autopair when next character is closing pair
			-- and there are more closing pairs than opening pairs
			skip_unbalanced = true,
			-- better deal with markdown code blocks
			markdown = true,
		})
	end,
}
