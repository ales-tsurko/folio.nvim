-- Folio palette.
--
-- Built on the e-ink.nvim look: neutral grey paper (#cccccc) and slate
-- (#3a3a3a), ink in plain greys, every background grey (diffs excepted).
-- Changes to it:
--   * every kind of word has its own grey, spaced far enough apart to be
--     seen: functions darkest, then keywords (bold), then body text, then
--     types (italic), then punctuation, then comments;
--   * colour on very few things — strings, constants, escapes — and there
--     at the edge of the gamut: neon on a grey page.
local util = require("folio.util")

local M = {}

M.variants = {
  light = {
    -- paper by contrast level: bg / dim (cursorline, bars) / deep / visual
    paper = {
      soft = { bg = "#c2c2c2", bg_dim = "#b8b8b8", bg_deep = "#aeaeae", bg_visual = "#a4a4a4" },
      medium = { bg = "#cccccc", bg_dim = "#c2c2c2", bg_deep = "#b8b8b8", bg_visual = "#aeaeae" },
      hard = { bg = "#d9d9d9", bg_dim = "#cecece", bg_deep = "#c3c3c3", bg_visual = "#b8b8b8" },
    },
    -- the contrast ladder: each kind of word gets its own grey; body text
    -- stays soft, important words get stronger ink. Steps are wider than
    -- in dark, because thin dark strokes on a light page blur together.
    ink = {
      fg_strong = "#0d0d0d", -- functions: calls
      fg_def = "#0d0d0d", --    definitions (bold)
      fg_dark = "#333333", --   keywords (bold), titles
      fg = "#505050", --        body: variables, fields, parameters
      fg2 = "#666666", --       types (italic), self/this
      fg3 = "#808080", --       operators, punctuation, borders
      comment = "#969696", --   comments (italic)
      fg4 = "#a0a0a0", --       line numbers, hints
      fg5 = "#b3b3b3", --       guides, whitespace
    },
    -- spot colours at the edge of the gamut: rare, and loud when they appear
    accent = {
      red = "#e4091c", --    errors
      orange = "#fe5101", -- strings (peak sRGB chroma for the hue)
      yellow = "#ca7f0a", -- warnings
      green = "#0ba22d", --  additions
      teal = "#0e9a94", --   hints
      blue = "#0670ee", --   info, links
      violet = "#910cfc", -- renames, misc UI
      pink = "#ff05a9", --   constants, escapes (peak chroma)
    },
    -- terminal "bright" colours
    bright = {
      red = "#ca0617",
      orange = "#e54800",
      yellow = "#b6720c",
      green = "#0a9028",
      teal = "#088984",
      blue = "#0462d3",
      violet = "#8008de",
      pink = "#e60298",
    },
  },

  dark = {
    -- a slate a shade lighter than e-ink.nvim's #333
    paper = {
      soft = { bg = "#444444", bg_dim = "#4e4e4e", bg_deep = "#585858", bg_visual = "#656565" },
      medium = { bg = "#3a3a3a", bg_dim = "#444444", bg_deep = "#4e4e4e", bg_visual = "#5b5b5b" },
      hard = { bg = "#2d2d2d", bg_dim = "#373737", bg_deep = "#414141", bg_visual = "#4e4e4e" },
    },
    -- bold text reads brighter on a dark page (the strokes bloom), so bold
    -- roles sit well below the plain ones next to them: bold keywords share
    -- the body grey and stand out by weight alone
    ink = {
      fg_strong = "#f0f0f0",
      fg_def = "#d2d2d2",
      fg_dark = "#b1b1b1",
      fg = "#adadad",
      fg2 = "#9a9a9a",
      fg3 = "#878787",
      comment = "#787878",
      fg4 = "#6b6b6b",
      fg5 = "#545454",
    },
    accent = {
      red = "#fe564d",
      orange = "#ff7024",
      yellow = "#fcd513",
      green = "#12f348",
      teal = "#19e8df",
      blue = "#5aa8fd",
      violet = "#b57cfe",
      pink = "#ff44b0",
    },
    bright = {
      red = "#fe796d",
      orange = "#fe853e",
      yellow = "#ffe892",
      green = "#6dff79",
      teal = "#1ffaf1",
      blue = "#7ab9fe",
      violet = "#c095fe",
      pink = "#fe56a3",
    },
  },
}

local accents = { "red", "orange", "yellow", "green", "teal", "blue", "violet", "pink" }

--- Build the colour table for a variant ("light" | "dark").
---@param variant string
---@param config table
---@return table
function M.get(variant, config)
  local v = M.variants[variant] or M.variants.light
  local c = vim.tbl_extend("force", {}, v.paper[config.contrast] or v.paper.medium, v.ink, v.accent)
  c.variant = variant
  c.none = "NONE"
  c.bright = vim.deepcopy(v.bright)

  if config.on_colors then
    config.on_colors(c)
  end

  -- Tinted backgrounds for diffs, search and diagnostics: accent washed into
  -- the paper, like a highlighter pen.
  for _, name in ipairs(accents) do
    c[name .. "_tint"] = util.blend(c[name], c.bg, variant == "dark" and 0.16 or 0.15)
    c[name .. "_wash"] = util.blend(c[name], c.bg, variant == "dark" and 0.32 or 0.30)
  end

  -- Syntax roles: which ink each kind of token gets.
  local mono = config.mono
  c.syntax = {
    keyword = c.fg_dark,
    definition = c.fg_def,
    call = c.fg_strong,
    type = c.fg2,
    string = mono and c.fg2 or c.orange,
    constant = mono and c.fg2 or c.pink,
    special = mono and c.fg3 or c.pink,
  }
  if config.on_syntax then
    config.on_syntax(c.syntax, c)
  end
  return c
end

return M
