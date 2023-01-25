local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Проводник
map("n", "<leader>e", ":Neotree right toggle<cr>", opts)

-- Dashboard
vim.keymap.set("n", "<leader>d", ":Dashboard<cr>", { desc = "Dashboard" })

-- Дебагинг
map("n", "<F9>", ":lua require('dap').toggle_breakpoint()<cr>", opts)
map("n", "<F5>", ":lua require('dap').continue()<cr>", opts)
map("n", "<F6>", ":lua require('dapui').toggle()<cr>", opts)

-- Telescope
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})

-- nvim
vim.keymap.set("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })
vim.keymap.set("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })
vim.keymap.set({ "i", "v", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

-- Двигать строку
vim.keymap.set("n", "<A-j>", ":m .+1<cr>==", { desc = "Move down" })
vim.keymap.set("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
vim.keymap.set("i", "<A-j>", "<Esc>:m .+1<cr>==gi", { desc = "Move down" })
vim.keymap.set("n", "<A-k>", ":m .-2<cr>==", { desc = "Move up" })
vim.keymap.set("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })
vim.keymap.set("i", "<A-k>", "<Esc>:m .-2<cr>==gi", { desc = "Move up" })

-- Окна
vim.keymap.set("n", "<leader>ww", "<C-W>p", { desc = "Other window" })
vim.keymap.set("n", "<leader>wd", "<C-W>c", { desc = "Delete window" })
vim.keymap.set("n", "<leader>w-", "<C-W>s", { desc = "Split window below" })
vim.keymap.set("n", "<leader>w|", "<C-W>v", { desc = "Split window right" })
vim.keymap.set("n", "<leader>-", "<C-W>s", { desc = "Split window below" })
vim.keymap.set("n", "<leader>|", "<C-W>v", { desc = "Split window right" })

-- switch between source and header
map("n", "<A-o>", "<Cmd>SwitchSourceAndHeader<CR>", opts)
-- generate the function definition or static variable definition in source
map("n", "<leader>cf", "<Cmd>ImplementInSource<CR>", opts)
-- generate the function definition or static variable definition in source in visual mode
map("v", "<leader>cf", '<Cmd>lua require("cppassist").ImplementInSourceInVisualMode<CR>', opts)
-- generate the function definition or static variable definition in header
map("n", "<leader>cv", "<Cmd>ImplementOutOfClass<CR>", opts)
-- goto the header file
map("n", "<leader>gh", "<Cmd>GotoHeaderFile<CR>", opts)
