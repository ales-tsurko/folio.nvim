-- Regenerate the terminal themes from the palette:
--
--   nvim -l extras/generate.lua
--
-- Writes extras/{kitty,wezterm,ghostty,alacritty}/folio-{light,dark}.
local root = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p:h:h")
vim.opt.rtp:prepend(root)

local folio = require("folio")
local terminal = require("folio.terminal")

local function write(path, text)
  vim.fn.mkdir(vim.fn.fnamemodify(path, ":h"), "p")
  local f = assert(io.open(path, "w"))
  f:write(text)
  f:close()
  print("wrote " .. path:sub(#root + 2))
end

local function header(name)
  return "# " .. name .. " — generated from the folio palette by extras/generate.lua"
end

local templates = {}

function templates.kitty(c, name, ansi)
  local lines = {
    header(name),
    "",
    "foreground " .. c.fg,
    "background " .. c.bg,
    "selection_foreground none",
    "selection_background " .. c.bg_visual,
    "cursor " .. c.fg_strong,
    "cursor_text_color " .. c.bg,
    "url_color " .. c.blue,
    "active_border_color " .. c.fg3,
    "inactive_border_color " .. c.fg5,
    "bell_border_color " .. c.orange,
    "tab_bar_background " .. c.bg,
    "active_tab_foreground " .. c.bg,
    "active_tab_background " .. c.fg_dark,
    "inactive_tab_foreground " .. c.fg2,
    "inactive_tab_background " .. c.bg_visual,
    "",
  }
  for i, color in ipairs(ansi) do
    lines[#lines + 1] = ("color%d %s"):format(i - 1, color)
  end
  return table.concat(lines, "\n") .. "\n"
end

-- a colour scheme file for ~/.config/wezterm/colors/
function templates.wezterm(c, name, ansi)
  local function list(from, to)
    local quoted = {}
    for i = from, to do
      quoted[#quoted + 1] = '"' .. ansi[i] .. '"'
    end
    return "[" .. table.concat(quoted, ", ") .. "]"
  end
  return table.concat({
    header(name),
    "[metadata]",
    ('name = "%s"'):format(name),
    "",
    "[colors]",
    ('foreground = "%s"'):format(c.fg),
    ('background = "%s"'):format(c.bg),
    ('cursor_bg = "%s"'):format(c.fg_strong),
    ('cursor_fg = "%s"'):format(c.bg),
    ('cursor_border = "%s"'):format(c.fg_strong),
    ('selection_bg = "%s"'):format(c.bg_visual),
    ('selection_fg = "%s"'):format(c.fg_strong),
    ('split = "%s"'):format(c.fg3),
    ('scrollbar_thumb = "%s"'):format(c.bg_deep),
    "ansi = " .. list(1, 8),
    "brights = " .. list(9, 16),
    "",
  }, "\n")
end

-- a theme file for ~/.config/ghostty/themes/
function templates.ghostty(c, name, ansi)
  local lines = {
    header(name),
    "background = " .. c.bg,
    "foreground = " .. c.fg,
    "cursor-color = " .. c.fg_strong,
    "cursor-text = " .. c.bg,
    "selection-background = " .. c.bg_visual,
    "selection-foreground = " .. c.fg_strong,
  }
  for i, color in ipairs(ansi) do
    lines[#lines + 1] = ("palette = %d=%s"):format(i - 1, color)
  end
  return table.concat(lines, "\n") .. "\n"
end

function templates.alacritty(c, name, ansi)
  local names = { "black", "red", "green", "yellow", "blue", "magenta", "cyan", "white" }
  local lines = {
    header(name),
    "[colors.primary]",
    ('background = "%s"'):format(c.bg),
    ('foreground = "%s"'):format(c.fg),
    "",
    "[colors.cursor]",
    ('cursor = "%s"'):format(c.fg_strong),
    ('text = "%s"'):format(c.bg),
    "",
    "[colors.selection]",
    ('background = "%s"'):format(c.bg_visual),
    ('text = "%s"'):format(c.fg_strong),
  }
  for _, block in ipairs({ { "normal", 0 }, { "bright", 8 } }) do
    lines[#lines + 1] = ""
    lines[#lines + 1] = "[colors." .. block[1] .. "]"
    for i = 1, 8 do
      lines[#lines + 1] = ('%s = "%s"'):format(names[i], ansi[i + block[2]])
    end
  end
  return table.concat(lines, "\n") .. "\n"
end

local extension = { kitty = ".conf", wezterm = ".toml", ghostty = "", alacritty = ".toml" }

for _, variant in ipairs({ "light", "dark" }) do
  local c = folio.colors(variant)
  local ansi = terminal.ansi(c)
  local name = "folio-" .. variant
  for tool, template in pairs(templates) do
    write(("%s/extras/%s/%s%s"):format(root, tool, name, extension[tool]), template(c, name, ansi))
  end
end
