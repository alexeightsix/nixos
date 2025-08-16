vim.api.nvim_set_hl(0, "GitConflictCurrent", { bg = "#4a8c89", fg = "#e0e0e0" })
vim.api.nvim_set_hl(0, "GitConflictIncoming", { bg = "#4a7bb5", fg = "#e0e0e0" })
vim.api.nvim_set_hl(0, "GitConflictAncestor", { bg = "#b0b0b0", fg = "#333333" })
vim.api.nvim_set_hl(0, "GitConflictCurrentLabel", { fg = "#e0e0e0", bg = "#4a8c89", bold = true })
vim.api.nvim_set_hl(0, "GitConflictIncomingLabel", { fg = "#e0e0e0", bg = "#4a7bb5", bold = true })

require("git-conflict").setup({
  default_mappings = true,     -- disable buffer local mapping created by this plugin
  default_commands = true,     -- disable commands created by this plugin
  disable_diagnostics = false, -- This will disable the diagnostics in a buffer whilst it is conflicted
  list_opener = 'copen',       -- command or function to open the conflicts list
  highlights = {               -- They must have background color, otherwise the default color will be used
    incoming = 'DiffAdd',
    current = 'DiffText',
  }
})
