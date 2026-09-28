local M = {}

--- The 16 ANSI colours for a colour table, index 1 = color0.
---@param c table colours from folio.palette
---@return string[]
function M.ansi(c)
  local b = c.bright
  local light = c.variant == "light"
  return {
    light and c.fg_dark or c.bg_deep, -- 0  black
    c.red, --                            1
    c.green, --                          2
    c.yellow, --                         3
    c.blue, --                           4
    c.pink, --                           5  magenta
    c.teal, --                           6  cyan
    light and c.fg4 or c.fg2, --         7  white
    light and c.fg3 or c.fg4, --         8  bright black
    b.red, --                            9
    b.green, --                          10
    b.yellow, --                         11
    b.blue, --                           12
    b.pink, --                           13
    b.teal, --                           14
    light and c.fg2 or c.fg_strong, --   15 bright white
  }
end

--- Set vim.g.terminal_color_0..15 for :terminal buffers.
function M.apply(c)
  for i, color in ipairs(M.ansi(c)) do
    vim.g["terminal_color_" .. (i - 1)] = color
  end
end

return M
