return {
  'mhartington/formatter.nvim',
  dependencies = { "elentok/format-on-save.nvim" },
  config = function()
    local format_on_save = require("format-on-save")
    local formatters = require("format-on-save.formatters")

    format_on_save.setup({
      exclude_path_patterns = {
        "/node_modules/",
        ".local/share/nvim/lazy",
      },
      formatter_by_ft = {
        clangd = formatters.lsp,
        css = formatters.lsp,
        html = formatters.lsp,
        java = formatters.lsp,
        javascript = formatters.lsp,
        json = formatters.lsp,
        lua = formatters.lsp,
        markdown = formatters.prettierd,
        python = formatters.black,
        rust = formatters.lsp,
        sh = formatters.shfmt,
        typescript = formatters.prettierd,
        typescriptreact = formatters.prettierd,
        yaml = formatters.lsp,
      }
    })
  end
}
