vim.api.nvim_create_user_command("E", function()
    vim.cmd("Ex")
end, {})

-- Built-in undo tree (Neovim 0.12). Load it on first use, not at each start.
vim.keymap.set("n", "<leader>u", function()
    vim.cmd.packadd("nvim.undotree")
    vim.cmd.Undotree()
end, { desc = "Undotree toggle" })

-- Move selection down/up
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Append following line to current with a space
vim.keymap.set(
    "n", "J", "mzJ`z",
    { desc = "Move next line to end of current" }
)

-- Move up and down while keeping the cursor in the middle
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page down (cursor centered)" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page up (cursor centered)" })

-- Jump between search results while keeping the cursor in the middle
vim.keymap.set("n", "n", "nzzzv", { desc = "Next hit (cursor centered)" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous hit (cursor centered)" })

-- Paste into selection without copying it
vim.keymap.set(
    "x", "<leader>p", [["_dP]],
    { desc = "Paste into selection without copying it" }
)

-- Copy into system clipboard
vim.keymap.set(
    { "n", "v" }, "<leader>y", [["+y]],
    { desc = "Copy selection to system clipboard" }
)
vim.keymap.set(
    "n", "<leader>Y", [["+Y]],
    { desc = "Copy line to system clipboard" }
)

-- Delete into void register
vim.keymap.set(
    { "n", "v" }, "<leader>d", "\"_d",
    { desc = "Delete into void register" }
)

-- Search and replace selection
vim.keymap.set(
    "n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
    { desc = "Search and replace current word" }
)
