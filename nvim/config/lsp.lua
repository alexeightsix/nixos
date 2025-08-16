local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview

function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = {
    { "╭", "FloatBorder" },
    { "─", "FloatBorder" },
    { "╮", "FloatBorder" },
    { "│", "FloatBorder" },
    { "╯", "FloatBorder" },
    { "─", "FloatBorder" },
    { "╰", "FloatBorder" },
    { "│", "FloatBorder" },
  }
  opts.pad_top = 0.1
  opts.pad_bottom = 0.1
  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

local handlers = {
  ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover),
  ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help),
}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

vim.lsp.config("*", {
  capabilities = capabilities,
  root_markers = { ".git" },
  handlers = handlers,
})

vim.lsp.enable("astro")
vim.lsp.enable("clangd")
vim.lsp.enable("cssls")
vim.lsp.enable("docker_compose_language_service")
vim.lsp.enable("dockerls")
vim.lsp.enable("eslint")
vim.lsp.enable("golangci_lint_ls")
vim.lsp.enable("gopls")
vim.lsp.enable("intelephense")
vim.lsp.enable("lua_ls")
vim.lsp.enable("luals")
vim.lsp.enable("pyright")
vim.lsp.enable("rnix")
vim.lsp.enable("ruby_lsp")
vim.lsp.enable("rust_analyzer")
vim.lsp.enable("tailwindcss")
vim.lsp.enable("templ")
vim.lsp.enable("ts_ls")
vim.lsp.enable("zls")
