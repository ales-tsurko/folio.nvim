-- Editor UI, after e-ink.nvim: every background is grey. Floats share the
-- page and get a border, selections are grey bands, search inverts the ink.
return function(hl, c, config)
  local bg = config.transparent and c.none or c.bg

  hl.Normal = { fg = c.fg, bg = bg }
  if config.dim_inactive then
    hl.NormalNC = { fg = c.fg, bg = c.bg_dim }
  end
  hl.NormalFloat = { fg = c.fg, bg = bg }
  hl.FloatBorder = { fg = c.fg3, bg = bg }
  hl.FloatTitle = { fg = c.fg_def, bg = bg, bold = true }
  hl.FloatFooter = { fg = c.fg3, bg = bg, italic = true }

  -- cursor & lines
  hl.Cursor = { fg = c.bg, bg = c.fg_strong }
  hl.lCursor = { link = "Cursor" }
  hl.CursorIM = { link = "Cursor" }
  hl.TermCursor = { reverse = true }
  hl.CursorLine = { bg = c.bg_dim }
  hl.CursorColumn = { bg = c.bg_dim }
  hl.ColorColumn = { bg = c.bg_dim }
  hl.LineNr = { fg = c.fg4 }
  hl.CursorLineNr = { fg = c.fg_def, bold = true }
  hl.SignColumn = { fg = c.fg4 }
  hl.FoldColumn = { fg = c.fg4 }
  hl.Folded = { fg = c.fg3, bg = c.bg_dim, italic = true }
  hl.WinSeparator = { fg = c.fg3 }
  hl.EndOfBuffer = { fg = config.transparent and c.fg5 or c.bg }
  hl.NonText = { fg = c.fg4 }
  hl.Whitespace = { fg = c.fg5 }
  hl.SpecialKey = { fg = c.fg4 }
  hl.Conceal = { fg = c.fg4 }

  -- selection & search, e-ink style: grey bands and inverted ink
  hl.Visual = { bg = c.bg_visual }
  hl.VisualNOS = { link = "Visual" }
  hl.Search = { fg = c.bg, bg = c.fg3 }
  hl.CurSearch = { fg = c.bg, bg = c.fg, bold = true }
  hl.IncSearch = { link = "CurSearch" }
  hl.Substitute = { fg = c.bg, bg = c.fg2 }
  hl.MatchParen = { fg = c.fg_def, bg = c.bg_deep, bold = true }
  hl.QuickFixLine = { bg = c.bg_dim, bold = true }

  -- popup menu: a darker sheet; the selection is the same grey band as a
  -- visual selection (plugins paint coloured kinds on it, so no inversion)
  hl.Pmenu = { fg = c.fg, bg = c.bg_dim }
  hl.PmenuSel = { fg = c.fg_strong, bg = c.bg_visual }
  hl.PmenuKind = { fg = c.fg3, bg = c.bg_dim }
  hl.PmenuKindSel = { fg = c.fg2, bg = c.bg_visual }
  hl.PmenuExtra = { fg = c.fg3, bg = c.bg_dim, italic = true }
  hl.PmenuExtraSel = { fg = c.fg2, bg = c.bg_visual, italic = true }
  hl.PmenuMatch = { fg = c.fg_def, bg = c.bg_dim, bold = true }
  hl.PmenuMatchSel = { fg = c.fg_def, bg = c.bg_visual, bold = true }
  hl.PmenuSbar = { bg = c.bg_dim }
  hl.PmenuThumb = { bg = c.fg5 }
  hl.PmenuBorder = { fg = c.fg3, bg = c.bg_dim }
  hl.ComplHint = { fg = c.fg4, italic = true }
  hl.ComplHintMore = { fg = c.fg3, italic = true }
  hl.PreInsert = { fg = c.fg4 }
  hl.WildMenu = { link = "PmenuSel" }

  -- bars
  hl.StatusLine = { fg = c.fg_dark, bg = bg, bold = true }
  hl.StatusLineNC = { fg = c.fg4, bg = bg }
  hl.StatusLineTerm = { link = "StatusLine" }
  hl.StatusLineTermNC = { link = "StatusLineNC" }
  hl.TabLine = { fg = c.fg2, bg = c.bg_visual }
  hl.TabLineFill = { bg = bg }
  hl.TabLineSel = { fg = c.fg_def, bg = bg, bold = true }
  hl.WinBar = { fg = c.fg, bg = c.bg_visual }
  hl.WinBarNC = { fg = c.fg2, bg = c.bg_visual }

  -- messages
  hl.MsgArea = { fg = c.fg }
  hl.MsgSeparator = { fg = c.fg3, bg = bg }
  hl.ModeMsg = { fg = c.fg_def, bold = true }
  hl.MoreMsg = { fg = c.fg2, bold = true }
  hl.Question = { fg = c.fg_def, bold = true }
  hl.ErrorMsg = { fg = c.red, bold = true }
  hl.WarningMsg = { fg = c.yellow, bold = true }
  hl.OkMsg = { fg = c.green }
  hl.StderrMsg = { link = "ErrorMsg" }
  hl.StdoutMsg = { fg = c.fg }
  hl.Title = { fg = c.fg_def, bold = true }
  hl.Directory = { fg = c.fg_dark, bold = true }

  -- spelling: undercurl in the colour of the problem
  hl.SpellBad = { sp = c.red, undercurl = true }
  hl.SpellCap = { sp = c.yellow, undercurl = true }
  hl.SpellLocal = { sp = c.teal, undercurl = true }
  hl.SpellRare = { sp = c.violet, undercurl = true }

  -- diffs: washes of colour behind unchanged ink
  hl.DiffAdd = { bg = c.green_tint }
  hl.DiffChange = { bg = c.blue_tint }
  hl.DiffDelete = { fg = c.red_wash, bg = c.red_tint }
  hl.DiffText = { bg = c.blue_wash }
  hl.DiffTextAdd = { bg = c.green_wash }
  hl.Added = { fg = c.green }
  hl.Changed = { fg = c.blue }
  hl.Removed = { fg = c.red }

  -- diagnostics
  local diagnostics = {
    Error = { "red", "undercurl" },
    Warn = { "yellow", "undercurl" },
    Info = { "blue", "underdotted" },
    Hint = { "teal", "underdotted" },
    Ok = { "green", "underline" },
  }
  for kind, spec in pairs(diagnostics) do
    local color, line = c[spec[1]], spec[2]
    hl["Diagnostic" .. kind] = { fg = color }
    hl["DiagnosticVirtualText" .. kind] = { fg = color, italic = true }
    hl["DiagnosticUnderline" .. kind] = { sp = color, [line] = true }
    hl["DiagnosticSign" .. kind] = { fg = color }
    hl["DiagnosticFloating" .. kind] = { fg = color }
    hl["DiagnosticVirtualLines" .. kind] = { fg = color }
  end
  hl.DiagnosticUnnecessary = { fg = c.fg4 }
  hl.DiagnosticDeprecated = { sp = c.fg3, strikethrough = true }

  -- LSP UI
  hl.LspReferenceText = { bg = c.bg_deep }
  hl.LspReferenceRead = { link = "LspReferenceText" }
  hl.LspReferenceWrite = { bg = c.bg_deep, underline = true, sp = c.fg3 }
  hl.LspReferenceTarget = { link = "LspReferenceText" }
  hl.LspSignatureActiveParameter = { fg = c.fg_def, bg = c.bg_deep, bold = true }
  hl.LspInlayHint = { fg = c.fg4, italic = true }
  hl.LspCodeLens = { fg = c.fg4, italic = true }
  hl.LspCodeLensSeparator = { fg = c.fg5 }
  hl.LspInfoBorder = { link = "FloatBorder" }
  hl.SnippetTabstop = { bg = c.bg_deep }
  hl.SnippetTabstopActive = { link = "SnippetTabstop" }
end
