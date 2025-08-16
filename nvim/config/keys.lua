local telescope = require("telescope.builtin")
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
      log.setup()
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
