-- Folio palette.
--
-- The page is e-ink.nvim's, unchanged: its grey paper (#cccccc) and slate
-- (#333333), its cursorline and selection greys, and — for every word —
-- only greys from its 16-level ramp, so no word gets more contrast than
-- e-ink allows. Within that range each kind of word has its own grey, and
-- bold and italic do the rest.
--
-- Colour is rare: literal values and escapes. Strings are a warm grey with
-- only a trace of hue, since in data files they are most of the page.
-- Accents are defined in OKLCH as a lightness and a hue; their chroma is
-- `saturation` times the most the sRGB gamut allows there (0 = grey,
-- 1 = neon).
local util = require("folio.util")

local M = {}

M.variants = {
  light = {
    -- paper by contrast level: bg / dim (cursorline, menus) / deep / visual
    paper = {
      soft = { bg = "#c2c2c2", bg_dim = "#b8b8b8", bg_deep = "#aeaeae", bg_visual = "#a4a4a4" },
      medium = { bg = "#cccccc", bg_dim = "#c2c2c2", bg_deep = "#b8b8b8", bg_visual = "#aeaeae" },
      hard = { bg = "#d6d6d6", bg_dim = "#cccccc", bg_deep = "#c2c2c2", bg_visual = "#b8b8b8" },
    },
    -- ink, all from e-ink.nvim's ramp: the more a word matters, the darker.
    -- Bold strokes already read darker, so bold words get lighter ink than
    -- their weight suggests: weight alone marks them, contrast stays e-ink.
    ink = {
      fg_strong = "#333333", -- function calls
      fg_def = "#474747", --    function definitions, emphasis (bold)
      fg_dark = "#5e5e5e", --   keywords, titles (bold)
      fg = "#5e5e5e", --        body: variables, fields, parameters
      fg2 = "#727272", --       types (italic), self/this
      fg3 = "#868686", --       operators, punctuation, borders
      comment = "#909090", --   comments (italic)
      fg4 = "#9a9a9a", --       line numbers, hints
      fg5 = "#aeaeae", --       guides, whitespace
    },
    -- { lightness, hue } in OKLCH
    accent = {
      red = { 0.52, 27 }, --     errors
      orange = { 0.58, 45 }, --  jump labels, conflicts, insert mode
      yellow = { 0.60, 75 }, --  warnings
      green = { 0.55, 140 }, --  additions
      teal = { 0.56, 190 }, --   hints
      blue = { 0.52, 255 }, --   info, changes
      violet = { 0.50, 305 }, -- renames, misc UI
      pink = { 0.56, 355 }, --   numbers, booleans, nil, escapes
    },
    -- strings: a warm grey, only a trace of hue
    sepia = { 0.50, 60 },
  },

  dark = {
    paper = {
      soft = { bg = "#3d3d3d", bg_dim = "#4a4a4a", bg_deep = "#545454", bg_visual = "#5e5e5e" },
      medium = { bg = "#333333", bg_dim = "#474747", bg_deep = "#4d4d4d", bg_visual = "#545454" },
      hard = { bg = "#292929", bg_dim = "#3d3d3d", bg_deep = "#474747", bg_visual = "#4a4a4a" },
    },
    -- bold strokes bloom on a dark page, so bold words sit below the plain
    -- words next to them
    ink = {
      fg_strong = "#cccccc",
      fg_def = "#aeaeae",
      fg_dark = "#9a9a9a",
      fg = "#aeaeae",
      fg2 = "#9a9a9a",
      fg3 = "#868686",
      comment = "#727272",
      fg4 = "#686868",
      fg5 = "#545454",
    },
    accent = {
      red = { 0.70, 27 },
      orange = { 0.76, 50 },
      yellow = { 0.84, 88 },
      green = { 0.80, 140 },
      teal = { 0.80, 190 },
      blue = { 0.74, 252 },
      violet = { 0.72, 305 },
      pink = { 0.72, 355 },
    },
    sepia = { 0.76, 65 },
  },
}

local accents = { "red", "orange", "yellow", "green", "teal", "blue", "violet", "pink" }

--- Build the colour table for a variant ("light" | "dark").
---@param variant string
---@param config table
---@return table
function M.get(variant, config)
  local v = M.variants[variant] or M.variants.light
  local c = vim.tbl_extend("force", {}, v.paper[config.contrast] or v.paper.medium, v.ink)
  c.variant = variant
  c.none = "NONE"

  -- accents at the chosen saturation; terminal "bright" colours are a step
  -- further from the paper and a little more saturated
  local s = math.max(0, math.min(1, config.saturation or 0.6))
  local step = variant == "dark" and 0.06 or -0.05
  c.bright = {}
  for _, name in ipairs(accents) do
    local L, h = v.accent[name][1], v.accent[name][2]
    c[name] = util.oklch(L, s * util.max_chroma(L, h), h)
    c.bright[name] = util.oklch(L + step, math.min(1, s * 1.25) * util.max_chroma(L + step, h), h)
  end
  local sL, sh = v.sepia[1], v.sepia[2]
  c.sepia = util.oklch(sL, 0.35 * s * util.max_chroma(sL, sh), sh)

  if config.on_colors then
    config.on_colors(c)
  end

  -- Tinted backgrounds for diffs: accent washed into the paper.
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
    string = mono and c.fg2 or c.sepia,
    constant = mono and c.fg2 or c.pink,
    special = mono and c.fg3 or c.pink,
  }
  if config.on_syntax then
    config.on_syntax(c.syntax, c)
  end
  return c
end

return M
