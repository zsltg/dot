return {
	"saghen/blink.cmp",
	-- Snippets for the snippet source. blink.cmp expands them with vim.snippet.
	dependencies = { "rafamadriz/friendly-snippets" },
	-- Use a release tag to download the prebuilt fuzzy matcher.
	version = "1.*",
	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		-- Tab accepts. All presets have these mappings:
		-- C-space: open the menu, or the documentation when the menu is open
		-- C-n/C-p or Up/Down: select the next/previous item
		-- C-e: hide the menu
		-- C-k: toggle the signature help
		keymap = {
			preset = "super-tab",
		},
		appearance = {
			nerd_font_variant = "mono",
		},
		completion = {
			-- Show the documentation popup only on C-space.
			documentation = { auto_show = false },
			list = { trigger = { show_in_snippet = false } },
		},
		sources = {
			default = { "lazydev", "lsp", "path", "snippets", "buffer" },
			providers = {
				-- Neovim Lua API completion, only in Lua files.
				lazydev = {
					name = "LazyDev",
					module = "lazydev.integrations.blink",
					score_offset = 100,
				},
			},
		},
		fuzzy = { implementation = "prefer_rust_with_warning" },
		signature = {
			enabled = true,
			trigger = {
				show_on_accept = true,
			},
			window = {
				show_documentation = true,
			},
		},
	},
}
