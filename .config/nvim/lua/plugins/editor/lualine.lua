return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons", "meuter/lualine-so-fancy.nvim" },
  config = function()
    require('lualine').setup({
      sections = {
        lualine_c = {
          {
            require("nvim-possession").status,
            cond = function()
              return require("nvim-possession").status() ~= nil
            end,
          }
        },
        lualine_x = { 'filetype' },
        lualine_y = { 'progress', "fancy_lsp_servers" },
      }
    })
  end
}
