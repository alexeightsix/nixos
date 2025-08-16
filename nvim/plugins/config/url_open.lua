local status_ok, url_open = pcall(require, "url-open")
if not status_ok then
  return
end

url_open.setup({
  open_app = "default",
  open_only_when_cursor_on_url = false,
  highlight_url = {
    all_urls = {
      enabled = false,
      fg = "#ffb86c",     -- "text" or "#rrggbb"
      bg = nil,           -- nil or "#rrggbb"
      underline = true,
    },
    cursor_move = {
      enabled = true,
      fg = "#ffb86c",     -- "text" or "#rrggbb"
      bg = nil,           -- nil or "#rrggbb"
      underline = true,
    },
  },
  deep_pattern = false,
})
