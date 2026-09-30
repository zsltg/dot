require("zsltg.set")
require("zsltg.remap")
require("zsltg.lazy")

vim.diagnostic.config({
  virtual_text = {
    prefix = "■",    -- or "", ">>", "■" (custom marker)
    source = "if_many", -- show source name only if multiple
--    spacing = 4,     -- extra padding on the right
  },
  signs = false,         -- show in sign column
  underline = true,     -- underline the text
  update_in_insert = false,
})
