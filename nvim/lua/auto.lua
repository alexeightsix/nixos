vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.loader.enable()

vim.g.loaded_netrwPlugin = 0

vim.opt.backup = false            -- creates a backup file
vim.opt.clipboard = "unnamedplus" -- allows neovim to access the system clipboard
vim.opt.cmdheight = 1             -- more space in the neovim command line for displaying messages
vim.opt.colorcolumn = "99999"     -- fixes indentline for now
vim.opt.completeopt = { "menuone", "noselect" }
vim.opt.conceallevel = 0          -- so that `` is visible in markdown files
vim.opt.cursorline = true         -- highlight the current line
vim.opt.expandtab = true          -- convert tabs to spaces
vim.opt.fileencoding = "utf-8"    -- the encoding written to a file
vim.opt.foldexpr = ""             -- set to "nvim_treesitter#foldexpr()" for treesitter based folding
vim.opt.foldmethod = "manual"     -- folding set to "expr" for treesitter based folding
vim.opt.hidden = true             -- required to keep multiple buffers and open multiple buffers
vim.opt.hlsearch = true           -- highlight all matches on previous search pattern
vim.opt.ignorecase = true         -- ignore case in search patterns
vim.opt.mouse = ""                -- allow the mouse to be used in neovim
vim.opt.nu = true
vim.opt.number = true             -- set numbered lines
vim.opt.numberwidth = 4           -- set number column width to 2 {default 4}
vim.opt.pumheight = 10            -- pop up menu height
vim.opt.relativenumber = true     -- set relative numbered lines
vim.opt.scrolloff = 8             -- is one of my fav
vim.opt.shiftwidth = 2            -- the number of spaces inserted for each indentation
vim.opt.showmode = false          -- we don't need to see things like -- INSERT -- anymore
vim.opt.showtabline = 0           -- always show tabs
vim.opt.sidescrolloff = 8
vim.opt.signcolumn = "yes"        -- always show the sign column otherwise it would shift the text each time
vim.opt.smartcase = true          -- smart case
vim.opt.smartindent = true        -- make indenting smarter again
vim.opt.spell = false
vim.opt.spelllang = "en"
vim.opt.splitbelow = true                  -- force all horizontal splits to go below current window
vim.opt.splitright = true                  -- force all vertical splits to go to the right of current window
vim.opt.swapfile = false                   -- creates a swapfile
vim.opt.tabstop = 2                        -- insert 2 spaces for a tab
vim.opt.termguicolors = true               -- set term gui colors (most terminals support this)
vim.opt.timeoutlen = 500                   -- time to wait for a mapped sequence to complete (in milliseconds)
vim.opt.title = true                       -- set the title of window to the value of the titlestring
vim.opt.titlestring = "%<%F%=%l/%L - nvim" -- what the title of the window will be set to
vim.opt.undodir = vim.fn.stdpath("cache") .. "/undo"
vim.opt.undofile = true                    -- enable persistent undo
vim.opt.updatetime = 300                   -- faster completion
vim.opt.wrap = false                       -- display lines as one long line
vim.opt.writebackup = false                -- if a file is being edited by another program (or was written to file while editing with another program) it is not allowed to be edited

vim.diagnostic.config({
  virtual_text = true,
  float = false,
  jump = {
    float = false,
  },
  update_in_insert = false,
})


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

local lsp_servers = {
  "eslint",
  "gopls",
  "intelephense",
  "lua_ls",
  "tailwindcss",
  "templ",
  "ts_ls",
  "rnix",
  -- "astro",
  -- "rust_analyzer",
  -- "clangd",
  -- "cssls",
  -- "docker_compose_language_service",
  -- "dockerls",
  -- "golangci_lint_ls",
  -- "pyright",
  -- "ruby_lsp",
  -- "zls",
}

-- require("lspconfig").lua_ls.setup(
--   {settings = {
--     diagnostics = {globals = { "vim"}}}
--
-- vim.lsp.enable("luals")
-- vim.lsp.enable("gopls")
--
local telescope = require("telescope.builtin")
-- local print_ln = require("custom.log")
local extensions = require("telescope").extensions

vim.keymap.set("n", "g]", function()
  local current_pos = vim.api.nvim_win_get_cursor(0)
  local diagnostics = vim.diagnostic.get(0)
  local target_diag

  for _, d in ipairs(diagnostics) do
    if d.lnum > current_pos[1] - 1 or (d.lnum == current_pos[1] - 1 and d.col > current_pos[2]) then
      target_diag = d
      break
    end
  end

  if not target_diag and #diagnostics > 0 then
    vim.api.nvim_win_set_cursor(0, { diagnostics[1].lnum + 1, diagnostics[1].col })
  else
    vim.diagnostic.jump({ float = false, wrap = false, count = 1 })
  end
end)


vim.api.nvim_create_autocmd("LspAttach", {
  callback = function()
    vim.keymap.set("n", "<S-k>", function()
      vim.lsp.buf.hover()
    end)

    vim.keymap.set("n", "@l", function()
      -- print_ln.setup()
    end)

    vim.keymap.set("n", "<leader>rn", function()
      vim.lsp.buf.rename()
    end)


    local function organizeImports()
      local params = vim.lsp.util.make_range_params(nil, vim.lsp.util._get_offset_encoding())
      params.context = { only = { "source.organizeImports" } }
      local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
      for _, res in pairs(result or {}) do
        for _, r in pairs(res.result or {}) do
          if r.kind == "source.organizeImports" then
            if r.edit then
              vim.lsp.util.apply_workspace_edit(r.edit, vim.lsp.util._get_offset_encoding())
            else
              print(r.command)
              vim.lsp.buf.execute_command(r.command)
            end
          end
        end
      end
    end

    vim.keymap.set("n", "<leader>fd", function()
      require("conform").format(
        {
          lsp_format = "fallback",
          async = true
        })

      local ft = vim.api.nvim_buf_get_option(0, "filetype")

      if ft == "go" then
        organizeImports()
      end
    end)

    vim.keymap.set("n", "<leader>ca", function()
      vim.lsp.buf.code_action()
    end)

    vim.keymap.set("n", "<leader>fr", function() -- find references
      telescope.lsp_references({
        initial_mode = "normal",
        jump_type = "never",
      })
    end)

    vim.keymap.set("n", "@cn", function()
      local line = vim.api.nvim_get_current_line()
      local new_line = line:gsub('className="([^"]+)"', 'className={cn("%1")}')
      vim.api.nvim_set_current_line(new_line)

      local ft = vim.api.nvim_buf_get_option(0, "filetype")

      if ft == "typescriptreact" then
        vim.lsp.buf.code_action({
          apply = true,
          context = { only = { "source.addMissingImports.ts" }, diagnostics = {} },
        })
      end
    end)

    vim.keymap.set("n", "<leader>wd", function()
      telescope.diagnostics({
        initial_mode = "normal",
      })
    end)

    vim.api.nvim_set_keymap("n", "<Leader>ls", ":LspRestart <CR>", { silent = true, noremap = true })


    vim.keymap.set("n", "<leader>fs", function()
      require("telescope.builtin").lsp_document_symbols({
        truncate = false,
        layout_strategy = "horizontal",
        layout_config = {
          preview_width = 0.5,
        },
      })
    end)

    vim.keymap.set("n", "gd", function()
      telescope.lsp_definitions({
        initial_mode = "normal",
      })
    end)
  end,
})

vim.keymap.set("n", "gd", "<Nop>")

vim.api.nvim_set_keymap("n", "<Leader>gh", ":OpenInGHFileLines <CR>", { silent = true, noremap = true })

vim.keymap.set("n", "<leader>ff", function()
  vim.fn.system("git rev-parse --is-inside-work-tree")
  if vim.v.shell_error == 0 then
    telescope.git_files({
      show_untracked = true,
    })
  else
    telescope.find_files()
  end
end)

vim.keymap.set("n", "<leader>rg", function()
  telescope.registers({
    initial_mode = "normal",
  })
end)

vim.keymap.set("n", "<leader>t", "<CMD>lua vim.diagnostic.open_float(0, {scope='line'})<CR>")

vim.keymap.set("n", "<S-Tab>", function()
  local quickfix_list = vim.fn.getqflist()
  local current_idx = vim.fn.getqflist({ idx = 0 }).idx
  if current_idx == #quickfix_list then
    vim.cmd("cc 1")
  else
    vim.cmd("cc " .. (current_idx + 1))
  end
end, { noremap = true, silent = true })

vim.keymap.set("n", "<leader>faf", function()
  telescope.find_files({
    no_ignore = true,
    hidden = true,
  })
end)

vim.keymap.set("n", "<leader>s", function()
  return ":%s/"
end, { expr = true })

vim.keymap.set("v", "<leader>s", function()
  return ":s/"
end, { expr = true })

vim.keymap.set("n", "<leader>faw", function()
  telescope.live_grep({
    no_ignore = true,
    hidden = true,
  })
end)

vim.keymap.set("n", "<leader>of", function()
  telescope.oldfiles({
    only_cwd = true,
    initial_mode = "normal",
  })
end)

vim.keymap.set("n", "<leader>fW", function()
  local word = vim.fn.expand("<cword>")

  if word == "" then
    return telescope.live_grep()
  end

  telescope.grep_string({
    initial_mode = "normal",
  })
end)

vim.keymap.set("n", "<leader>fw", function()
  extensions.live_grep_args.live_grep_args({
    initial_mode = "insert",
  })
end)

vim.api.nvim_create_user_command("OilToggle", function()
  local current_buf = vim.api.nvim_get_current_buf()
  local current_filetype = vim.api.nvim_buf_get_option(current_buf, "filetype")
  if current_filetype == "oil" then
    require("oil").toggle_float()
  else
    require("oil").toggle_float()
  end
end, { nargs = 0 })

vim.keymap.set("n", "<leader>e", "<CMD>:OilToggle<CR>")

vim.keymap.set("n", "<leader>td", "<CMD>Gitsigns toggle_deleted<CR>")

vim.keymap.set("n", "<leader>bl", "<CMD>Gitsigns blame_line<CR>")

vim.keymap.set("n", "gx", "<CMD>URLOpenUnderCursor<CR>")

vim.keymap.set("n", "<leader>ut", "<CMD>:UndotreeToggle<CR>")

vim.keymap.set("n", "<leader>nc", function()
  vim.cmd("cd ~/.config/nvim")
  vim.cmd("e init.lua")
end)

vim.api.nvim_set_keymap("i", "<C-Right>", 'copilot#Accept("<CR>")', { silent = true, expr = true })

vim.keymap.set({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

vim.keymap.set("n", "<leader>rw", function()
  require('grug-far').toggle_instance({
    instanceName = "far",
    staticTitle = "Find and Replace",
    startInInsertMode = false,
  })
end)

vim.cmd([[
  command! W write
  command! Bd bdelete
]])

local harpoon = require("harpoon")
local harpoon_extensions = require("harpoon.extensions")
harpoon:setup()
harpoon:extend(harpoon_extensions.builtins.highlight_current_file())
vim.keymap.set("n", "<leader>ba", function()
  harpoon:list():add()
  local current_file = vim.fn.expand("%:p")
  vim.notify("+ " .. current_file)
end)

vim.keymap.set("n", "<leader>bd", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

local conf = require("telescope.config").values
local function toggle_telescope(harpoon_files)
  local file_paths = {}
  for _, item in ipairs(harpoon_files.items) do
    table.insert(file_paths, item.value)
  end

  require("telescope.pickers").new({}, {
    prompt_title = "Harpoon",
    finder = require("telescope.finders").new_table({
      results = file_paths,
    }),
    initial_mode = "normal",
    previewer = conf.file_previewer({}),
    sorter = conf.generic_sorter({}),
  }):find()
end

vim.keymap.set("n", "<leader>fb", function() toggle_telescope(harpoon:list()) end)

vim.api.nvim_set_keymap("t", "<Esc>", "<C-\\><C-n>", { noremap = true, silent = true })

vim.lsp.enable('gopls')
