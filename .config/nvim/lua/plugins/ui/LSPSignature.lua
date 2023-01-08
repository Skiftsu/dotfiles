return {
  "ray-x/lsp_signature.nvim",
  event = "LspAttach",
  opts = {
  },
  config = function(_, opts)
    -- vim.lsp.signature.enabled = false

    require 'lsp_signature'.setup(opts)
  end
}
