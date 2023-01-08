return {
  "p00f/clangd_extensions.nvim",
  config = function()
    require("clangd_extensions").setup(
      require("clangd_extensions.inlay_hints").setup_autocmd()
    )
  end
}
