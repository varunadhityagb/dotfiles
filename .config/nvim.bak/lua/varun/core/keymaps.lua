vim.g.mapleader = " "

local keymap = vim.keymap.set
keymap("", "<Space>", "<Nop>", opts)
keymap("n", "<leader>h", ":nohlsearch<CR>", { desc = "Clear search highlights" })

keymap("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
keymap("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
keymap("n", "<leader>se", "<C-w>=", { desc = "Split equal" })
keymap("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })

keymap("n", "<Leader>1", "1gt<CR>", opts)
keymap("n", "<Leader>2", "2gt<CR>", opts)
keymap("n", "<Leader>3", "3gt<CR>", opts)
keymap("n", "<Leader>4", "4gt<CR>", opts)
keymap("n", "<Leader>5", "5gt<CR>", opts)

keymap("n", "<Leader>t", "<cmd> tabnew<CR>", opts)
keymap("n", "<Leader>c", "<cmd> tabclose<CR>", opts)

keymap("i", "jj", "<ESC>", opts)
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

keymap("n", "<leader>a", ":Alpha<CR>", opts)

keymap("n", "<leader>ff", ":Telescope find_files<CR>", opts)
keymap("n", "<leader>ft", ":Telescope live_grep<CR>", opts)
keymap("n", "<leader>fp", ":Telescope zoxide list<CR>", opts)
keymap("n", "<leader>fb", ":Telescope buffers<CR>", opts)
keymap("n", "<space>fe", ":Telescope file_browser<CR>", opts)

keymap("n", "<leader>/", "<cmd>lua require('Comment.api').toggle.linewise.current()<CR>", opts)
keymap("x", "<leader>/", '<ESC><CMD>lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>')

keymap({ "n", "v", "i" }, "<leader>nt", ":split term://zsh<CR>", opts)
