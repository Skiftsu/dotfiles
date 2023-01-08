return {
  "neovim/nvim-lspconfig",
  dependencies = { "williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim" },
  config = function()
    require("mason-lspconfig").setup({
      ensure_installed = {
        "lua_ls", "rust_analyzer"
      },
      automatic_installation = true,
    })

    require 'lspconfig'.clangd.setup {}
    require 'lspconfig'.lua_ls.setup {}
    require 'lspconfig'.rust_analyzer.setup {}
    require 'lspconfig'.jdtls.setup {}
  end
}
