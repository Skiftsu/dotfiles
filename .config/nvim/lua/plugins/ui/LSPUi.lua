return {
  "jinzhongjia/LspUI.nvim",
  branch = "legacy",
  config = function()
    require("LspUI").setup({
      -- config options go here
      prompt = false
    })
  end
}
