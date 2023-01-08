return {
  "stevearc/overseer.nvim",
  config = function()
    require("overseer").setup({
      templates = { "builtin", "CMake" },
      strategy = { "toggleterm" },
    })
  end,
}
