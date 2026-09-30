return {
    "craftzdog/solarized-osaka.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
        require("solarized-osaka").setup({
            on_highlights = function(hl, c)
                -- Default
                hl.NormalFloat = {
                    bg = c.base02,
                }
                hl.LineNr = {
                    fg = c.base01,
                }
                -- blink.cmp
                hl.BlinkCmpSignatureHelpActiveParameter = {
                    fg = c.base2,
                    bold = true,
                }
                -- Telescope
                hl.TelescopeNormal = {
                    bg = c.bg_dark,
                    fg = c.fg_dark,
                }
                hl.TelescopeBorder = {
                    bg = c.bg_dark,
                    fg = c.bg_dark,
                }
                hl.TelescopePreviewTitle = {
                    bg = c.bg_dark,
                    fg = c.bg_dark,
                }
                hl.TelescopeResultsTitle = {
                    bg = c.bg_dark,
                    fg = c.bg_dark,
                }
            end,
        })
        vim.cmd("colorscheme solarized-osaka")
    end,
}
