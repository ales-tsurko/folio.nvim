-- lualine theme. Picked up by `theme = "auto"` while folio is active; lualine
-- re-runs this file whenever the colorscheme or 'background' changes.
--
-- The bar sits on the page like e-ink.nvim's; the mode is an inverted label,
-- and the only colour is the mode itself.
local c = require("folio").colors()

local function mode(color)
  return {
    a = { fg = c.bg, bg = color, gui = "bold" },
    b = { fg = c.fg_dark, bg = c.bg_visual },
    c = { fg = c.fg, bg = c.bg },
  }
end

local muted = { fg = c.fg4, bg = c.bg }

return {
  normal = mode(c.fg_dark),
  insert = mode(c.orange),
  visual = mode(c.pink),
  replace = mode(c.red),
  command = mode(c.yellow),
  terminal = mode(c.teal),
  inactive = { a = muted, b = muted, c = muted },
}
