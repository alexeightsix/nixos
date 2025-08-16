require("conform").setup({
  formatters_by_ft = {
    ruby = {
      "rubocop"
    },
    blade = {
      "blade-formatter",
    },
    lua = {
      "stylua"
    },
    javascript = {
      "prettierd",
      "prettier",
      stop_after_first = true
    },
  }
})
