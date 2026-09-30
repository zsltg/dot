vim.api.nvim_create_user_command("E", function()
    vim.cmd("Ex")
end, {})

vim.g.mapleader = " "
--vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- Move selection down/up
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

--vim.api.nvim_set_keymap("n", "<leader>tf", "<Plug>PlenaryTestFile", { noremap = false, silent = false })

-- Append following line to current with a space
vim.keymap.set(
    "n", "J", "mzJ`z",
    { desc = "Move next line to end of current" }
)

-- Move up and down while keeping the cursor in the middle
--vim.keymap.set("n", "<C-d>", "<C-d>zz")
--vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Jump between search results while keeping the cursor in the middle
vim.keymap.set("n", "n", "nzzzv", { desc = "Next hit (cursor centered)" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous hit (cursor centered)" })

--vim.keymap.set("n", "=ap", "ma=ap'a")
--vim.keymap.set("n", "<leader>zig", "<cmd>LspRestart<cr>")

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

---- This is going to get me cancelled
--vim.keymap.set("i", "<C-c>", "<Esc>")

--vim.keymap.set("n", "Q", "<nop>")

-- tmux-sessionizer
--vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
--vim.keymap.set("n", "<M-h>", "<cmd>silent !tmux-sessionizer -s 0 --vsplit<CR>")
--vim.keymap.set("n", "<M-H>", "<cmd>silent !tmux neww tmux-sessionizer -s 0<CR>")

-- Quickfix and Location navigation
--vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
--vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
--vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
--vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- Search and replace selection
vim.keymap.set(
    "n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
    { desc = "Search and replace current word" }
)

--vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

--vim.keymap.set(
--    "n",
--    "<leader>ee",
--    "oif err != nil {<CR>}<Esc>Oreturn err<Esc>"
--)

--vim.keymap.set(
--    "n",
--    "<leader>ea",
--    "oassert.NoError(err, \"\")<Esc>F\";a"
--)

--vim.keymap.set(
--    "n",
--    "<leader>ef",
--    "oif err != nil {<CR>}<Esc>Olog.Fatalf(\"error: %s\\n\", err.Error())<Esc>jj"
--)

--vim.keymap.set(
--    "n",
--    "<leader>el",
--    "oif err != nil {<CR>}<Esc>O.logger.Error(\"error\", \"error\", err)<Esc>F.;i"
--)

--vim.keymap.set("n", "<leader>ca", function()
--    require("cellular-automaton").start_animation("make_it_rain")
--end)

--vim.keymap.set("n", "<leader><leader>", function()
--    vim.cmd("so")
--end)
