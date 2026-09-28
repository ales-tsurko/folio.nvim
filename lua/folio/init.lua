local M = {}

---@class FolioConfig
M.defaults = {
  -- Paper brightness: "soft" | "medium" | "hard".
  contrast = "medium",
  -- Leave the background to the terminal.
  transparent = false,
  -- Give unfocused windows a slightly darker paper.
  dim_inactive = false,
  -- Define vim.g.terminal_color_0..15.
  terminal_colors = true,
  -- How much colour the accents carry: 0 = grey, 1 = neon (the most the
  -- sRGB gamut allows for each hue).
  saturation = 0.6,
  -- Pure greyscale syntax: colour only for diagnostics and diffs.
  mono = false,
  -- Font variants per syntax role. Any nvim_set_hl() attributes work here,
  -- e.g. `keywords = { bold = false, italic = true }`.
  styles = {
    comments = { italic = true },
    keywords = { bold = true },
    definitions = { bold = true },
    types = { italic = true },
    strings = {},
    constants = {},
    parameters = {},
    builtins = { italic = true },
  },
  -- function(colors) — change the palette before anything uses it.
  on_colors = nil,
  -- function(syntax, colors) — change which colour each syntax role uses.
  on_syntax = nil,
  -- function(highlights, colors) — change or add highlight groups.
  on_highlights = nil,
}

M.config = vim.deepcopy(M.defaults)

---@param opts? FolioConfig
function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", vim.deepcopy(M.defaults), opts or {})
end

--- The colour table for the current (or given) background.
---@param variant? "light"|"dark"
function M.colors(variant)
  return require("folio.palette").get(variant or vim.o.background, M.config)
end

function M.load()
  if vim.g.colors_name then
    vim.cmd("highlight clear")
  end
  vim.o.termguicolors = true
  vim.g.colors_name = "folio"

  local c = M.colors()
  local groups = require("folio.groups").get(c, M.config)
  for name, spec in pairs(groups) do
    vim.api.nvim_set_hl(0, name, spec)
  end

  if M.config.terminal_colors then
    require("folio.terminal").apply(c)
  end
end

return M
