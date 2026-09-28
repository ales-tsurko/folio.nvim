-- Folio palette.
--
-- A page of e-paper: a matte mid-grey sheet with a faint cool cast, neither
-- quite light nor quite dark, printed in dense ink. Code is set like a
-- book: the same dark ink throughout, with weight and slant for structure
-- (bold keywords and definitions, cursive types) and a lighter grey for
-- punctuation. Comments are pencil notes in the margin: grey cursive.
--
-- Two coloured inks, as on a two-colour print: blue-black for strings and a
-- rubric red for literal values (numbers, booleans, nil) and escapes. The
-- other accents only mark state (diagnostics, diffs, git).
--
-- Colours are given in OKLCH as { lightness, hue, strength }. Their chroma
-- is strength × `saturation` × the most sRGB allows at that lightness and
-- hue, so `saturation` runs from 0 (grey) to 1 (as vivid as it gets).
local util = require("folio.util")

local M = {}

M.variants = {
  light = {
    -- paper by contrast level: bg / dim (cursorline, menus) / deep / visual.
    -- A faint cool cast, like an e-ink panel, at the lightness of plain grey.
    paper = {
      soft = { bg = "#c0c3c4", bg_dim = "#b6b9ba", bg_deep = "#acafb0", bg_visual = "#a2a5a6" },
      medium = { bg = "#cacdce", bg_dim = "#c0c3c4", bg_deep = "#b6b9ba", bg_visual = "#acafb0" },
      hard = { bg = "#d4d7d8", bg_dim = "#cacdce", bg_deep = "#c0c3c4", bg_visual = "#b6b9ba" },
    },
    -- One dark ink for the code; bold words take a slightly lighter shade,
    -- since the heavier strokes already make them darker on the page.
    ink = {
      fg_strong = "#2e2e2e", -- cursor, selected items
      fg = "#2e2e2e", --        code: variables, fields, calls
      fg_def = "#2e2e2e", --    definitions (bold)
      fg_dark = "#474747", --   keywords, titles (bold)
      fg2 = "#4f4f4f", --       types (cursive), self/this
      fg3 = "#5e5e5e", --       punctuation, operators, modules, borders
      comment = "#767676", --   comments (cursive)
      fg4 = "#8a8a8a", --       line numbers, hints
      fg5 = "#a4a4a4", --       guides, whitespace
    },
    accent = {
      red = { 0.49, 22, 1.0 }, --      literal values, escapes, errors
      orange = { 0.56, 50, 0.9 }, --   jump labels, conflicts
      yellow = { 0.58, 80, 0.9 }, --   warnings
      green = { 0.52, 140, 0.8 }, --   additions
      teal = { 0.52, 190, 0.8 }, --    hints
      blue = { 0.44, 255, 0.92 }, --   strings (blue-black ink), info, changes
      violet = { 0.47, 305, 0.8 }, --  renames, misc UI
      pink = { 0.52, 350, 0.9 }, --    terminal magenta, visual mode
    },
  },

  dark = {
    -- a slate lifted towards mid-grey: a dark page, not a night one
    paper = {
      soft = { bg = "#595b5d", bg_dim = "#6d6f71", bg_deep = "#747678", bg_visual = "#7b7e7f" },
      medium = { bg = "#4b4d4f", bg_dim = "#606264", bg_deep = "#686a6c", bg_visual = "#6f7273" },
      hard = { bg = "#3e4042", bg_dim = "#545658", bg_deep = "#5c5e60", bg_visual = "#646668" },
    },
    ink = {
      fg_strong = "#d3d3d3",
      fg = "#d3d3d3",
      fg_def = "#d3d3d3",
      fg_dark = "#bcbcbc",
      fg2 = "#b4b4b4",
      fg3 = "#a4a4a4",
      comment = "#979797",
      fg4 = "#808080",
      fg5 = "#6f6f6f",
    },
    accent = {
      red = { 0.72, 20, 0.86 },
      orange = { 0.76, 55, 0.8 },
      yellow = { 0.82, 88, 0.8 },
      green = { 0.78, 140, 0.7 },
      teal = { 0.78, 190, 0.7 },
      blue = { 0.78, 250, 0.89 },
      violet = { 0.74, 305, 0.7 },
      pink = { 0.74, 350, 0.8 },
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
  local c = vim.tbl_extend("force", {}, v.paper[config.contrast] or v.paper.medium, v.ink)
  c.variant = variant
  c.none = "NONE"

  -- accents at the chosen saturation; terminal "bright" colours are a step
  -- further from the paper and a little more saturated
  local s = math.max(0, math.min(1, config.saturation or 0.6))
  local step = variant == "dark" and 0.06 or -0.05
  c.bright = {}
  for _, name in ipairs(accents) do
    local L, h, k = unpack(v.accent[name])
    c[name] = util.oklch(L, k * s * util.max_chroma(L, h), h)
    c.bright[name] = util.oklch(L + step, math.min(1, k * s * 1.25) * util.max_chroma(L + step, h), h)
  end

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
    string = mono and c.fg2 or c.blue,
    constant = mono and c.fg2 or c.red,
    special = mono and c.fg3 or c.red,
  }
  if config.on_syntax then
    config.on_syntax(c.syntax, c)
  end
  return c
end

return M
