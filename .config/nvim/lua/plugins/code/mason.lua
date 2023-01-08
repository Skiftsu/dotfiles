return {
    "williamboman/mason.nvim",
    dependencies = { "mfussenegger/nvim-lint" },
    config = function()
      require("mason").setup()
    end
}
