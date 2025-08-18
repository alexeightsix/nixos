local function augroup(name)
  return vim.api.nvim_create_augroup("augroup_" .. name, { clear = true })
end

vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function()
    vim.highlight.on_yank({
      timeout = 100
    })
  end,
})

vim.api.nvim_create_autocmd("VimEnter", {
  group = augroup("nvim_start"),
  pattern = "*",
  nested = true,
  callback = function()
    local a = vim.fn.expand("%")

    if require('plenary').path:new(a):exists() or a == "." then
      require("telescope.builtin").oldfiles({
        only_cwd = true,
        initial_mode = "normal",
      })
    end
  end,
})

vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI", "BufEnter", "InsertLeave" }, {
  callback = function()
    local params = { textDocument = vim.lsp.util.make_text_document_params() }
    local curr_pos = vim.api.nvim_win_get_cursor(0)

    local function find_func(symbols)
      for _, symbol in ipairs(symbols or {}) do
        if symbol.kind == 12 or symbol.kind == 6 then -- Function or Method
          local range = symbol.range or symbol.location.range
          local start_line = range.start.line + 1
          local end_line = range["end"].line + 1
          if curr_pos[1] >= start_line and curr_pos[1] <= end_line then
            local inner = find_func(symbol.children)
            if inner then return inner end
            return {
              name = symbol.name,
              line = start_line
            }
          end
        elseif symbol.children then
          local inner = find_func(symbol.children)
          if inner then return inner end
        end
      end
      return nil
    end

    local clients = vim.lsp.get_clients({ bufnr = 0 })
    for _, client in ipairs(clients) do
      if client.server_capabilities.documentSymbolProvider then
        client.request('textDocument/documentSymbol', params, function(_, result)
          local func = find_func(result)
          if func then
            vim.b.current_func = func.name
            vim.b.current_func_line = func.line
          else
            vim.b.current_func = nil
            vim.b.current_func_line = nil
          end
        end, 0)
      end
    end
  end,
})

function _G.statusline_func()
  if vim.b.current_func then
    return string.format(" %s:%d ", vim.b.current_func, vim.b.current_func_line or 0)
  end
  return ""
end

vim.o.statusline = "%f %{v:lua.statusline_func()} %m %r %= %y %l:%c"
