-- Биндинг через which-key
--local opts = { noremap = true, silent = true }
local wk = require("which-key")

local function map(mode, lhs, rhs, opts)
  local keys = require("lazy.core.handler").handlers.keys
  if not keys.active[keys.parse({ lhs, mode = mode }).id] then
    opts = opts or {}
    opts.silent = opts.silent ~= false
    if opts.remap and not vim.g.vscode then
      opts.remap = nil
    end
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

map('t', '<Esc>', [[<C-\><C-n>]])

map("n", "<leader>tt", "<cmd>ToggleTerm direction=horizontal<cr>", { desc = "Terminal" })

wk.register({
  e = { "<cmd>Neotree toggle<cr>", "FileExplorer" },
  f = { name = "Files" },
  n = { name = "Notification" },
  t = {
    name = "Telescope",
    f = { "<cmd>Telescope find_files theme=dropdown<cr>", "Find files" },
    b = { "<cmd>Telescope buffers<cr>", "Buffers" },
    g = { "<cmd>Telescope live_grep<cr>", "Find word" },
    n = { "<cmd>Telescope notify<cr>", "Notification history" }
    -- n = {
    -- },

  },
  l = {
    name = "LSP",
    r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename (LSP)" },
  },
  -- { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },

}, { prefix = "<leader>" })

map("n", "<leader>nn", function()
  require("notify").dismiss({ silent = true, pending = true })
end, { desc = "Dismiss all Notifications" })

map("n", "<C-f>", "<cmd>lua require('flash').jump()<cr>", { desc = "Flash" })
map("n", "<C-r>", "<cmd>OverseerRun<cr>", { desc = "Run Code" })
map("n", "<C-t>", "<cmd>OverseerToggle<cr>", { desc = "Run Code" })

map("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer" })
map("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
map("n", "<S-c>", "<cmd>Bdelete<cr>", { desc = "Close buffer" })

map("n", "<C-h>", "<C-w>h", { desc = "Go to left window", remap = true })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window", remap = true })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window", remap = true })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window", remap = true })

-- Дебагинг
map("n", "<F9>", ":lua require('dap').toggle_breakpoint()<cr>")
map("n", "<F5>", ":lua require('dap').continue()<cr>")
map("n", "<F6>", ":lua require('dapui').toggle()<cr>", { desc = "Togle DAP UI" })

-- nvim
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Close NVIM" })
map("n", "<leader>qe", "<cmd>q!<cr>", { desc = "Close window without saving" })
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })
map({ "i", "v", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

-- Двигать строку
map("n", "<A-j>", ":m .+1<cr>==", { desc = "Move down" })
map("i", "<A-j>", "<Esc>:m .+1<cr>==gi", { desc = "Move down" })
map("n", "<A-k>", ":m .-2<cr>==", { desc = "Move up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })
map("i", "<A-k>", "<Esc>:m .-2<cr>==gi", { desc = "Move up" })

-- Окна
map("n", "<leader>ww", "<C-W>p", { desc = "Other window" })
map("n", "<leader>wd", "<C-W>c", { desc = "Delete window" })
map("n", "<leader>w-", "<C-W>s", { desc = "Split window below" })
map("n", "<leader>w|", "<C-W>v", { desc = "Split window right" })
map("n", "<leader>-", "<C-W>s", { desc = "Split window below" })
map("n", "<leader>|", "<C-W>v", { desc = "Split window right" })

map("n", "<leader>D", ":Dashboard<cr>", { desc = "Dashboard" })


local t    = {}
-- Syntax: t[keys] = {function, {function arguments}}
t['<C-u>'] = { 'scroll', { '-vim.wo.scroll', 'true', '250' } }
t['<C-d>'] = { 'scroll', { 'vim.wo.scroll', 'true', '250' } }
t['<C-b>'] = { 'scroll', { '-vim.api.nvim_win_get_height(0)', 'true', '450' } }
t['<C-f>'] = { 'scroll', { 'vim.api.nvim_win_get_height(0)', 'true', '450' } }
t['<C-y>'] = { 'scroll', { '-0.10', 'false', '100' } }
t['<C-e>'] = { 'scroll', { '0.10', 'false', '100' } }
t['zt']    = { 'zt', { '250' } }
t['zz']    = { 'zz', { '250' } }
t['zb']    = { 'zb', { '250' } }

require('neoscroll.config').set_mappings(t)

local possession = require("nvim-possession")
vim.keymap.set("n", "<leader>sl", function()
  possession.list()
end)
vim.keymap.set("n", "<leader>sn", function()
  possession.new()
end)
vim.keymap.set("n", "<leader>su", function()
  possession.update()
end)
vim.keymap.set("n", "<leader>sd", function()
  possession.delete()
end)
