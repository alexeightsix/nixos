local log = {}

log.set_cursor = function()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>1jo<Esc>_", true, false, true), "n", false)
end

log.handle_php = function()
  vim.fn.append(vim.fn.line("."), "\tprint_r(" .. log.get_word() .. ");")
  log.set_cursor()
end

log.get_word = function()
  return vim.fn.expand("<cword>")
end

log.handle_tsx = function()
  vim.fn.append(vim.fn.line("."), "\tconsole.log(" .. log.get_word() .. ");")
  log.set_cursor()
end

log.handle_go = function()
  local word = log.get_word()
  local new_text = "\tgodump.Dump(" .. word .. ")"

  vim.fn.append(vim.fn.line("."), new_text)

  local errors = vim.diagnostic.get(0)

  if errors == nil then
    return
  end

  local params = vim.lsp.util.make_range_params()

  params.context = { only = { "source.organizeImports" } }

  local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)

  for cid, res in pairs(result or {}) do
    for _, r in pairs(res.result or {}) do
      if r.edit then
        local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
        vim.lsp.util.apply_workspace_edit(r.edit, enc)
      end
    end
  end

  log.set_cursor()
end

log.get_file_extension = function()
  return vim.fn.expand("%:e")
end

log.defaults = {
  ["go"] = log.handle_go,
  ["tsx"] = log.handle_tsx,
  ["jsx"] = log.handle_tsx,
  ["php"] = log.handle_php,
}

log.setup = function()
  local callback = log.defaults[log.get_file_extension()]

  if callback then
    callback()
  else
    vim.notify("printLn: Unsupported file type", vim.log.levels.ERROR)
  end
end
