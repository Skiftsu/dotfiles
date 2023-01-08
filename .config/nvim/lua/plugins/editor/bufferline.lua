return {
  'akinsho/bufferline.nvim',
  version = "*",
  dependencies = { 'nvim-tree/nvim-web-devicons', "famiu/bufdelete.nvim" },
  config = function()
    vim.opt.termguicolors = true
    require("bufferline").setup {}
  end
}
