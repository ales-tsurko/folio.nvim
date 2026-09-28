-- Plugin highlights. Same rules as the editor: grey backgrounds, lists
-- select with a grey band, matches are bold ink, colour only where it
-- carries meaning.
return function(hl, c, config)
  local bg = config.transparent and c.none or c.bg
  local syn = c.syntax

  local float = { fg = c.fg, bg = bg }
  local border = { fg = c.fg3, bg = bg }
  local title = { fg = c.fg_strong, bold = true }
  local label = { fg = c.bg, bg = c.fg, bold = true } -- inverted e-ink tab
  local selection = { bg = c.bg_visual }
  local match = { fg = c.fg_strong, bold = true }
  local muted = { fg = c.fg4 }

  -- LSP completion-item kinds (cmp, blink, noice, dropbar, ...) follow the
  -- same ladder as the code they stand for
  local kinds = {
    Text = c.fg3,
    Method = syn.call,
    Function = syn.call,
    Constructor = syn.call,
    Field = c.fg,
    Variable = c.fg,
    Property = c.fg,
    Reference = c.fg,
    Key = c.fg,
    Class = syn.type,
    Interface = syn.type,
    Struct = syn.type,
    Enum = syn.type,
    TypeParameter = syn.type,
    Type = syn.type,
    Object = syn.type,
    Array = syn.type,
    Module = c.fg3,
    Namespace = c.fg3,
    Package = c.fg3,
    Keyword = syn.keyword,
    Operator = c.fg3,
    Value = syn.constant,
    Unit = syn.constant,
    EnumMember = syn.constant,
    Constant = syn.constant,
    Boolean = syn.constant,
    Number = syn.constant,
    Null = syn.constant,
    String = syn.string,
    Snippet = c.yellow,
    Event = c.yellow,
    Color = c.orange,
    File = c.fg3,
    Folder = c.fg3,
    Copilot = c.teal,
    Codeium = c.teal,
    Supermaven = c.teal,
    TabNine = c.teal,
  }
  local function each_kind(prefix, suffix)
    for kind, color in pairs(kinds) do
      hl[prefix .. kind .. (suffix or "")] = { fg = color }
    end
  end

  -- nvim-cmp ------------------------------------------------------------------
  hl.CmpItemAbbr = { fg = c.fg }
  hl.CmpItemAbbrDeprecated = { fg = c.fg4, strikethrough = true }
  hl.CmpItemAbbrMatch = match
  hl.CmpItemAbbrMatchFuzzy = match
  hl.CmpItemMenu = { fg = c.fg4, italic = true }
  hl.CmpItemKind = { fg = c.fg3 }
  hl.CmpGhostText = { fg = c.fg4, italic = true }
  each_kind("CmpItemKind")

  -- blink.cmp -----------------------------------------------------------------
  hl.BlinkCmpMenu = { link = "Pmenu" }
  hl.BlinkCmpMenuBorder = { link = "PmenuBorder" }
  hl.BlinkCmpMenuSelection = { link = "PmenuSel" }
  hl.BlinkCmpScrollBarThumb = { link = "PmenuThumb" }
  hl.BlinkCmpScrollBarGutter = { link = "PmenuSbar" }
  hl.BlinkCmpLabel = { fg = c.fg }
  hl.BlinkCmpLabelMatch = match
  hl.BlinkCmpLabelDeprecated = { fg = c.fg4, strikethrough = true }
  hl.BlinkCmpLabelDetail = muted
  hl.BlinkCmpLabelDescription = muted
  hl.BlinkCmpSource = muted
  hl.BlinkCmpGhostText = { fg = c.fg4, italic = true }
  hl.BlinkCmpKind = { fg = c.fg3 }
  hl.BlinkCmpDoc = float
  hl.BlinkCmpDocBorder = border
  hl.BlinkCmpDocSeparator = { fg = c.fg5, bg = bg }
  hl.BlinkCmpSignatureHelp = float
  hl.BlinkCmpSignatureHelpBorder = border
  hl.BlinkCmpSignatureHelpActiveParameter = { link = "LspSignatureActiveParameter" }
  each_kind("BlinkCmpKind")

  -- telescope -----------------------------------------------------------------
  hl.TelescopeNormal = float
  hl.TelescopeBorder = border
  hl.TelescopeTitle = title
  hl.TelescopePromptNormal = float
  hl.TelescopePromptBorder = { fg = c.fg2, bg = bg }
  hl.TelescopePromptTitle = label
  hl.TelescopePromptPrefix = { fg = c.fg2 }
  hl.TelescopePromptCounter = muted
  hl.TelescopeResultsTitle = title
  hl.TelescopePreviewTitle = title
  hl.TelescopeSelection = { fg = c.fg_strong, bg = c.bg_visual }
  hl.TelescopeSelectionCaret = { fg = c.fg_strong, bg = c.bg_visual, bold = true }
  hl.TelescopeMultiSelection = { fg = c.blue, bold = true }
  hl.TelescopeMultiIcon = { fg = c.blue }
  hl.TelescopeMatching = match
  hl.TelescopePreviewLine = { bg = c.bg_dim }
  hl.TelescopePreviewMatch = { link = "Search" }
  hl.TelescopeResultsDiffAdd = { link = "Added" }
  hl.TelescopeResultsDiffChange = { link = "Changed" }
  hl.TelescopeResultsDiffDelete = { link = "Removed" }

  -- fzf-lua -------------------------------------------------------------------
  hl.FzfLuaNormal = float
  hl.FzfLuaBorder = border
  hl.FzfLuaTitle = title
  hl.FzfLuaCursorLine = selection
  hl.FzfLuaFzfMatch = match
  hl.FzfLuaFzfPrompt = { fg = c.fg2 }
  hl.FzfLuaFzfPointer = { fg = c.fg_strong }
  hl.FzfLuaHeaderBind = { fg = c.blue }
  hl.FzfLuaHeaderText = { fg = c.fg3 }
  hl.FzfLuaPathColNr = muted
  hl.FzfLuaPathLineNr = muted
  hl.FzfLuaBufNr = muted
  hl.FzfLuaTabMarker = { fg = c.fg_strong }
  hl.FzfLuaLivePrompt = { fg = c.fg }
  hl.FzfLuaLiveSym = { fg = c.blue, bold = true }

  -- snacks.nvim ---------------------------------------------------------------
  hl.SnacksNormal = float
  hl.SnacksWinBar = title
  hl.SnacksIndent = { fg = c.fg5 }
  hl.SnacksIndentScope = { fg = c.fg4 }
  hl.SnacksPickerMatch = match
  hl.SnacksPickerSelected = { fg = c.blue }
  hl.SnacksPickerDir = { fg = c.fg3 }
  hl.SnacksPickerPrompt = { fg = c.fg2 }
  hl.SnacksPickerTitle = label
  hl.SnacksDashboardHeader = { fg = c.fg3 }
  hl.SnacksDashboardKey = { fg = c.blue, bold = true }
  hl.SnacksDashboardDesc = { fg = c.fg }
  hl.SnacksDashboardIcon = { fg = c.fg3 }
  hl.SnacksDashboardFooter = { fg = c.fg4, italic = true }
  hl.SnacksDashboardSpecial = { fg = c.violet }

  -- neo-tree ------------------------------------------------------------------
  hl.NeoTreeNormal = { fg = c.fg, bg = bg }
  hl.NeoTreeNormalNC = { fg = c.fg, bg = bg }
  hl.NeoTreeEndOfBuffer = { link = "EndOfBuffer" }
  hl.NeoTreeWinSeparator = { link = "WinSeparator" }
  hl.NeoTreeCursorLine = { bg = c.bg_dim }
  hl.NeoTreeRootName = { fg = c.fg_strong, bold = true }
  hl.NeoTreeDirectoryName = { fg = c.fg }
  hl.NeoTreeDirectoryIcon = { fg = c.fg3 }
  hl.NeoTreeFileName = { fg = c.fg }
  hl.NeoTreeFileNameOpened = { fg = c.fg_strong, bold = true }
  hl.NeoTreeFileIcon = { fg = c.fg3 }
  hl.NeoTreeIndentMarker = { fg = c.fg5 }
  hl.NeoTreeExpander = muted
  hl.NeoTreeDotfile = muted
  hl.NeoTreeHiddenByName = muted
  hl.NeoTreeDimText = muted
  hl.NeoTreeFadeText1 = muted
  hl.NeoTreeFadeText2 = { fg = c.fg5 }
  hl.NeoTreeMessage = { fg = c.fg3, italic = true }
  hl.NeoTreeModified = { fg = c.yellow }
  hl.NeoTreeFilterTerm = match
  hl.NeoTreeSymbolicLinkTarget = { fg = c.teal, italic = true }
  hl.NeoTreeBufferNumber = muted
  hl.NeoTreeFileStats = muted
  hl.NeoTreeFileStatsHeader = { fg = c.fg3, italic = true }
  hl.NeoTreeGitAdded = { fg = c.green }
  hl.NeoTreeGitModified = { fg = c.blue }
  hl.NeoTreeGitDeleted = { fg = c.red }
  hl.NeoTreeGitRenamed = { fg = c.violet }
  hl.NeoTreeGitUntracked = { fg = c.teal, italic = true }
  hl.NeoTreeGitIgnored = muted
  hl.NeoTreeGitUnstaged = { fg = c.orange }
  hl.NeoTreeGitStaged = { fg = c.green }
  hl.NeoTreeGitConflict = { fg = c.red, bold = true }
  hl.NeoTreeFloatBorder = border
  hl.NeoTreeFloatTitle = title
  hl.NeoTreeTitleBar = label
  hl.NeoTreeTabActive = { fg = c.fg_strong, bg = bg, bold = true }
  hl.NeoTreeTabInactive = { fg = c.fg4, bg = c.bg_dim }
  hl.NeoTreeTabSeparatorActive = { fg = c.bg_dim, bg = bg }
  hl.NeoTreeTabSeparatorInactive = { fg = c.bg_dim, bg = c.bg_dim }

  -- nvim-tree -----------------------------------------------------------------
  hl.NvimTreeNormal = { fg = c.fg, bg = bg }
  hl.NvimTreeWinSeparator = { link = "WinSeparator" }
  hl.NvimTreeRootFolder = { fg = c.fg_strong, bold = true }
  hl.NvimTreeFolderName = { fg = c.fg }
  hl.NvimTreeOpenedFolderName = { fg = c.fg, bold = true }
  hl.NvimTreeEmptyFolderName = muted
  hl.NvimTreeFolderIcon = { fg = c.fg3 }
  hl.NvimTreeIndentMarker = { fg = c.fg5 }
  hl.NvimTreeOpenedFile = { fg = c.fg_strong, bold = true }
  hl.NvimTreeSpecialFile = { fg = c.fg, underline = true }
  hl.NvimTreeSymlink = { fg = c.teal }
  hl.NvimTreeGitNew = { fg = c.green }
  hl.NvimTreeGitDirty = { fg = c.blue }
  hl.NvimTreeGitDeleted = { fg = c.red }
  hl.NvimTreeGitStaged = { fg = c.green }
  hl.NvimTreeGitIgnored = muted

  -- oil.nvim ------------------------------------------------------------------
  hl.OilDir = { fg = c.fg, bold = true }
  hl.OilDirIcon = { fg = c.fg3 }
  hl.OilFile = { fg = c.fg }
  hl.OilLink = { fg = c.teal }
  hl.OilLinkTarget = { fg = c.fg3, italic = true }
  hl.OilOrphanLink = { fg = c.red }
  hl.OilSocket = { fg = c.violet }
  hl.OilHidden = muted
  hl.OilCreate = { fg = c.green, bold = true }
  hl.OilDelete = { fg = c.red, bold = true }
  hl.OilMove = { fg = c.yellow, bold = true }
  hl.OilCopy = { fg = c.teal, bold = true }
  hl.OilChange = { fg = c.blue, bold = true }
  hl.OilRestore = { fg = c.green }
  hl.OilPurge = { fg = c.red }
  hl.OilTrash = { fg = c.red }
  hl.OilTrashSourcePath = muted

  -- gitsigns ------------------------------------------------------------------
  hl.GitSignsAdd = { fg = c.green }
  hl.GitSignsChange = { fg = c.blue }
  hl.GitSignsDelete = { fg = c.red }
  hl.GitSignsTopdelete = { fg = c.red }
  hl.GitSignsChangedelete = { fg = c.orange }
  hl.GitSignsUntracked = { fg = c.fg4 }
  hl.GitSignsAddNr = { fg = c.green }
  hl.GitSignsChangeNr = { fg = c.blue }
  hl.GitSignsDeleteNr = { fg = c.red }
  hl.GitSignsAddLn = { bg = c.green_tint }
  hl.GitSignsChangeLn = { bg = c.blue_tint }
  hl.GitSignsDeleteLn = { bg = c.red_tint }
  hl.GitSignsAddInline = { bg = c.green_wash }
  hl.GitSignsChangeInline = { bg = c.blue_wash }
  hl.GitSignsDeleteInline = { bg = c.red_wash }
  hl.GitSignsAddPreview = { link = "DiffAdd" }
  hl.GitSignsDeletePreview = { link = "DiffDelete" }
  hl.GitSignsDeleteVirtLn = { fg = c.fg3, bg = c.red_tint }
  hl.GitSignsVirtLnum = muted
  hl.GitSignsCurrentLineBlame = { fg = c.fg4, italic = true }

  -- git: diffview, neogit, git-conflict, fugitive -----------------------------
  hl.DiffviewFilePanelTitle = title
  hl.DiffviewFilePanelCounter = { fg = c.fg3, bold = true }
  hl.DiffviewFilePanelFileName = { fg = c.fg }
  hl.DiffviewFilePanelPath = muted
  hl.DiffviewFilePanelRootPath = { fg = c.fg3, bold = true }
  hl.DiffviewFilePanelInsertions = { fg = c.green }
  hl.DiffviewFilePanelDeletions = { fg = c.red }
  hl.DiffviewFilePanelConflicts = { fg = c.orange }
  hl.DiffviewFilePanelSelected = { fg = c.yellow }
  hl.DiffviewFolderName = { fg = c.fg, bold = true }
  hl.DiffviewFolderSign = { fg = c.fg3 }
  hl.DiffviewDim1 = muted
  hl.DiffviewPrimary = { fg = c.blue }
  hl.DiffviewSecondary = { fg = c.teal }
  hl.DiffviewHash = { fg = c.violet }
  hl.DiffviewReference = { fg = c.blue }
  hl.DiffviewStatusAdded = { fg = c.green }
  hl.DiffviewStatusUntracked = { fg = c.teal }
  hl.DiffviewStatusModified = { fg = c.blue }
  hl.DiffviewStatusTypeChange = { fg = c.blue }
  hl.DiffviewStatusRenamed = { fg = c.violet }
  hl.DiffviewStatusCopied = { fg = c.violet }
  hl.DiffviewStatusUnmerged = { fg = c.orange }
  hl.DiffviewStatusDeleted = { fg = c.red }
  hl.DiffviewStatusBroken = { fg = c.red }
  hl.DiffviewStatusUnknown = { fg = c.red }
  hl.DiffviewStatusIgnored = muted
  hl.DiffviewDiffAddAsDelete = { bg = c.red_tint }
  hl.DiffviewDiffDelete = { fg = c.fg5 }

  hl.NeogitBranch = { fg = c.blue, bold = true }
  hl.NeogitBranchHead = { fg = c.blue, bold = true, underline = true }
  hl.NeogitRemote = { fg = c.violet, bold = true }
  hl.NeogitSectionHeader = { fg = c.fg_strong, bold = true }
  hl.NeogitObjectId = muted
  hl.NeogitStash = { fg = c.fg3 }
  hl.NeogitFilePath = { fg = c.blue, italic = true }
  hl.NeogitTagName = { fg = c.yellow }
  hl.NeogitHunkHeader = { fg = c.fg2, bg = c.bg_deep, bold = true }
  hl.NeogitHunkHeaderHighlight = { fg = c.fg_strong, bg = c.bg_visual, bold = true }
  hl.NeogitDiffHeader = { fg = c.fg_strong, bg = c.bg_deep, bold = true }
  hl.NeogitDiffHeaderHighlight = { fg = c.fg_strong, bg = c.bg_visual, bold = true }
  hl.NeogitDiffContext = { fg = c.fg2, bg = bg }
  hl.NeogitDiffContextHighlight = { fg = c.fg, bg = c.bg_dim }
  hl.NeogitDiffAdd = { fg = c.green, bg = c.green_tint }
  hl.NeogitDiffAddHighlight = { fg = c.green, bg = c.green_wash }
  hl.NeogitDiffDelete = { fg = c.red, bg = c.red_tint }
  hl.NeogitDiffDeleteHighlight = { fg = c.red, bg = c.red_wash }
  hl.NeogitChangeModified = { fg = c.blue, bold = true, italic = true }
  hl.NeogitChangeAdded = { fg = c.green, bold = true, italic = true }
  hl.NeogitChangeNewFile = { fg = c.green, bold = true, italic = true }
  hl.NeogitChangeDeleted = { fg = c.red, bold = true, italic = true }
  hl.NeogitChangeRenamed = { fg = c.violet, bold = true, italic = true }
  hl.NeogitChangeCopied = { fg = c.teal, bold = true, italic = true }
  hl.NeogitChangeUpdated = { fg = c.orange, bold = true, italic = true }
  hl.NeogitChangeUnmerged = { fg = c.orange, bold = true, italic = true }

  hl.GitConflictCurrent = { bg = c.green_tint }
  hl.GitConflictCurrentLabel = { bg = c.green_wash, bold = true }
  hl.GitConflictIncoming = { bg = c.blue_tint }
  hl.GitConflictIncomingLabel = { bg = c.blue_wash, bold = true }
  hl.GitConflictAncestor = { bg = c.violet_tint }
  hl.GitConflictAncestorLabel = { bg = c.violet_wash, bold = true }

  hl.diffAdded = { fg = c.green }
  hl.diffRemoved = { fg = c.red }
  hl.diffChanged = { fg = c.blue }
  hl.diffOldFile = { fg = c.red, italic = true }
  hl.diffNewFile = { fg = c.green, italic = true }
  hl.diffFile = { fg = c.fg_strong, bold = true }
  hl.diffLine = { fg = c.violet }
  hl.diffIndexLine = { fg = c.fg3 }
  hl.diffSubname = { fg = c.fg3 }
  hl.gitcommitSummary = { fg = c.fg_strong, bold = true }
  hl.gitcommitOverflow = { fg = c.red }
  hl.gitcommitBranch = { fg = c.blue, bold = true }
  hl.gitcommitSelectedFile = { fg = c.green }
  hl.gitcommitDiscardedFile = { fg = c.red }
  hl.gitcommitUntrackedFile = { fg = c.teal }
  hl.fugitiveHash = { fg = c.violet }
  hl.fugitiveStagedHeading = { fg = c.green, bold = true }
  hl.fugitiveUnstagedHeading = { fg = c.orange, bold = true }
  hl.fugitiveUntrackedHeading = { fg = c.teal, bold = true }

  -- which-key -----------------------------------------------------------------
  hl.WhichKey = { fg = c.fg_strong, bold = true }
  hl.WhichKeyGroup = { fg = c.blue }
  hl.WhichKeyDesc = { fg = c.fg }
  hl.WhichKeySeparator = muted
  hl.WhichKeyNormal = float
  hl.WhichKeyBorder = border
  hl.WhichKeyTitle = title
  hl.WhichKeyValue = muted
  hl.WhichKeyIcon = { fg = c.fg3 }
  hl.WhichKeyColorAzure = { fg = c.blue }
  hl.WhichKeyColorBlue = { fg = c.blue }
  hl.WhichKeyColorCyan = { fg = c.teal }
  hl.WhichKeyColorGreen = { fg = c.green }
  hl.WhichKeyColorGrey = { fg = c.fg3 }
  hl.WhichKeyColorOrange = { fg = c.orange }
  hl.WhichKeyColorPurple = { fg = c.violet }
  hl.WhichKeyColorRed = { fg = c.red }
  hl.WhichKeyColorYellow = { fg = c.yellow }

  -- mini.icons, mini.* --------------------------------------------------------
  hl.MiniIconsAzure = { fg = c.blue }
  hl.MiniIconsBlue = { fg = c.blue }
  hl.MiniIconsCyan = { fg = c.teal }
  hl.MiniIconsGreen = { fg = c.green }
  hl.MiniIconsGrey = { fg = c.fg3 }
  hl.MiniIconsOrange = { fg = c.orange }
  hl.MiniIconsPurple = { fg = c.violet }
  hl.MiniIconsRed = { fg = c.red }
  hl.MiniIconsYellow = { fg = c.yellow }
  hl.MiniIndentscopeSymbol = { fg = c.fg4 }
  hl.MiniCursorword = { underline = true, sp = c.fg4 }
  hl.MiniCursorwordCurrent = { underline = true, sp = c.fg4 }
  hl.MiniJump = { fg = c.bg, bg = c.fg }
  hl.MiniStatuslineModeNormal = label
  hl.MiniStatuslineModeInsert = { fg = c.bg, bg = c.blue, bold = true }
  hl.MiniStatuslineModeVisual = { fg = c.bg, bg = c.violet, bold = true }
  hl.MiniStatuslineModeReplace = { fg = c.bg, bg = c.red, bold = true }
  hl.MiniStatuslineModeCommand = { fg = c.bg, bg = c.yellow, bold = true }
  hl.MiniStatuslineModeOther = { fg = c.bg, bg = c.teal, bold = true }
  hl.MiniStatuslineDevinfo = { fg = c.fg, bg = c.bg_deep }
  hl.MiniStatuslineFilename = { fg = c.fg2, bg = c.bg_dim }
  hl.MiniStatuslineFileinfo = { fg = c.fg, bg = c.bg_deep }
  hl.MiniStatuslineInactive = { fg = c.fg4, bg = c.bg_dim }
  hl.MiniPickMatchCurrent = selection
  hl.MiniPickMatchRanges = match
  hl.MiniPickPrompt = { fg = c.fg2, bg = bg }
  hl.MiniPickBorder = border
  hl.MiniPickNormal = float
  hl.MiniFilesTitleFocused = title
  hl.MiniFilesDirectory = { fg = c.fg, bold = true }
  hl.MiniDiffSignAdd = { fg = c.green }
  hl.MiniDiffSignChange = { fg = c.blue }
  hl.MiniDiffSignDelete = { fg = c.red }
  hl.MiniClueTitle = title
  hl.MiniClueNextKey = { fg = c.fg_strong, bold = true }
  hl.MiniClueDescGroup = { fg = c.blue }
  hl.MiniHipatternsFixme = { fg = c.bg, bg = c.red, bold = true }
  hl.MiniHipatternsHack = { fg = c.bg, bg = c.yellow, bold = true }
  hl.MiniHipatternsTodo = { fg = c.bg, bg = c.blue, bold = true }
  hl.MiniHipatternsNote = { fg = c.bg, bg = c.teal, bold = true }
  hl.MiniStarterHeader = { fg = c.fg3 }
  hl.MiniStarterSection = title
  hl.MiniStarterItemPrefix = { fg = c.blue, bold = true }
  hl.MiniStarterQuery = match

  -- noice & nvim-notify -------------------------------------------------------
  hl.NoiceCmdlinePopup = float
  hl.NoiceCmdlinePopupBorder = border
  hl.NoiceCmdlinePopupTitle = title
  hl.NoiceCmdlineIcon = { fg = c.fg3 }
  hl.NoiceCmdlinePopupBorderSearch = { fg = c.yellow, bg = bg }
  hl.NoiceCmdlineIconSearch = { fg = c.yellow }
  hl.NoiceConfirmBorder = border
  hl.NoicePopupBorder = border
  hl.NoicePopupmenuBorder = { link = "PmenuBorder" }
  hl.NoicePopupmenuSelected = { link = "PmenuSel" }
  hl.NoicePopupmenuMatch = match
  hl.NoiceMini = { fg = c.fg3, bg = c.bg_dim }
  hl.NoiceVirtualText = { fg = c.fg4, italic = true }
  hl.NoiceLspProgressTitle = { fg = c.fg3 }
  hl.NoiceLspProgressClient = { fg = c.fg2, bold = true }
  hl.NoiceLspProgressSpinner = { fg = c.fg3 }
  hl.NoiceFormatProgressDone = { fg = c.bg, bg = c.fg3 }
  hl.NoiceFormatProgressTodo = { fg = c.fg, bg = c.bg_deep }
  hl.NoiceScrollbarThumb = { bg = c.fg4 }
  each_kind("NoiceCompletionItemKind")

  hl.NotifyBackground = { bg = c.bg }
  for level, color in pairs({ ERROR = c.red, WARN = c.yellow, INFO = c.blue, DEBUG = c.fg3, TRACE = c.violet }) do
    hl["Notify" .. level .. "Border"] = { fg = color, bg = bg }
    hl["Notify" .. level .. "Icon"] = { fg = color }
    hl["Notify" .. level .. "Title"] = { fg = color, bold = true }
    hl["Notify" .. level .. "Body"] = float
  end

  -- trouble -------------------------------------------------------------------
  hl.TroubleNormal = float
  hl.TroubleNormalNC = float
  hl.TroubleText = { fg = c.fg }
  hl.TroubleCount = { fg = c.fg2, bold = true }
  hl.TroubleFilename = { fg = c.fg, bold = true }
  hl.TroubleDirectory = { fg = c.fg3 }
  hl.TroubleIconDirectory = { fg = c.fg3 }
  hl.TroubleSource = muted
  hl.TroublePos = muted
  hl.TroubleCode = muted
  hl.TroubleIndent = { fg = c.fg5 }
  hl.TroublePreview = { bg = c.bg_deep }

  -- dropbar & incline (winbar) ------------------------------------------------
  hl.DropBarCurrentContext = { bg = c.bg_deep }
  hl.DropBarHover = { bg = c.bg_deep }
  hl.DropBarIconUISeparator = muted
  hl.DropBarIconUIIndicator = { fg = c.fg3 }
  hl.DropBarMenuCurrentContext = selection
  hl.DropBarMenuHoverEntry = selection
  hl.DropBarMenuHoverIcon = { fg = c.fg_strong, bg = c.bg_visual }
  hl.DropBarMenuNormalFloat = float
  hl.DropBarMenuFloatBorder = border
  each_kind("DropBarIconKind")
  hl.DropBarIconKindFolder = { fg = c.fg3 }
  hl.InclineNormal = { fg = c.fg, bg = c.bg_dim }
  hl.InclineNormalNC = { fg = c.fg4, bg = c.bg_dim }

  -- indent guides, context, twilight ------------------------------------------
  hl.IblIndent = { fg = c.fg5, nocombine = true }
  hl.IblWhitespace = { fg = c.fg5, nocombine = true }
  hl.IblScope = { fg = c.fg4, nocombine = true }
  hl.IndentBlanklineChar = { fg = c.fg5, nocombine = true }
  hl.IndentBlanklineContextChar = { fg = c.fg4, nocombine = true }
  hl.TreesitterContext = { bg = c.bg_dim }
  hl.TreesitterContextLineNumber = { fg = c.fg4, bg = c.bg_dim }
  hl.TreesitterContextBottom = { underline = true, sp = c.fg5 }
  hl.Twilight = { fg = c.fg4 }

  -- motions: flash, leap, hop, eyeliner ---------------------------------------
  hl.FlashBackdrop = { fg = c.fg4 }
  hl.FlashMatch = { fg = c.bg, bg = c.fg3 }
  hl.FlashCurrent = { fg = c.bg, bg = c.fg }
  hl.FlashLabel = { fg = c.bg, bg = c.orange, bold = true }
  hl.LeapBackdrop = { fg = c.fg4 }
  hl.LeapMatch = { fg = c.fg_strong, bold = true, underline = true }
  hl.LeapLabel = { fg = c.bg, bg = c.orange, bold = true }
  hl.HopNextKey = { fg = c.red, bold = true }
  hl.HopNextKey1 = { fg = c.blue, bold = true }
  hl.HopNextKey2 = { fg = c.blue }
  hl.HopUnmatched = { fg = c.fg4 }
  hl.EyelinerPrimary = { fg = c.fg_strong, bold = true, underline = true }
  hl.EyelinerSecondary = { fg = c.fg2, underline = true }
  hl.IlluminatedWordText = { link = "LspReferenceText" }
  hl.IlluminatedWordRead = { link = "LspReferenceRead" }
  hl.IlluminatedWordWrite = { link = "LspReferenceWrite" }

  -- markdown & notes: render-markdown, orgmode, vimwiki -----------------------
  hl.RenderMarkdownH1Bg = { bg = c.bg_deep }
  hl.RenderMarkdownH2Bg = { bg = c.bg_dim }
  hl.RenderMarkdownH3Bg = { bg = c.bg_dim }
  hl.RenderMarkdownH4Bg = { bg = c.bg_dim }
  hl.RenderMarkdownH5Bg = { bg = c.bg_dim }
  hl.RenderMarkdownH6Bg = { bg = c.bg_dim }
  hl.RenderMarkdownCode = { bg = c.bg_dim }
  hl.RenderMarkdownCodeInline = { fg = c.fg2, bg = c.bg_dim }
  hl.RenderMarkdownCodeInfo = { fg = c.fg3, italic = true }
  hl.RenderMarkdownBullet = { fg = c.fg3 }
  hl.RenderMarkdownDash = { fg = c.fg5 }
  hl.RenderMarkdownQuote = { fg = c.fg3 }
  hl.RenderMarkdownTableHead = { fg = c.fg3 }
  hl.RenderMarkdownTableRow = { fg = c.fg4 }
  hl.RenderMarkdownChecked = { fg = c.green }
  hl.RenderMarkdownUnchecked = { fg = c.fg3 }
  hl.RenderMarkdownTodo = { fg = c.yellow }
  hl.RenderMarkdownLink = { fg = c.blue }
  hl.RenderMarkdownSign = { fg = c.fg4 }
  hl.RenderMarkdownMath = { fg = syn.special }
  hl.RenderMarkdownInlineHighlight = { bg = c.bg_visual }

  hl["@org.headline.level1"] = { fg = syn.definition, bold = true }
  hl["@org.headline.level2"] = { fg = syn.definition, bold = true }
  hl["@org.headline.level3"] = { fg = c.fg, bold = true }
  hl["@org.headline.level4"] = { fg = c.fg, bold = true }
  hl["@org.headline.level5"] = { fg = c.fg2, bold = true }
  hl["@org.headline.level6"] = { fg = c.fg2, bold = true }
  hl["@org.headline.level7"] = { fg = c.fg2, italic = true }
  hl["@org.headline.level8"] = { fg = c.fg2, italic = true }
  hl["@org.leading_stars"] = { fg = c.fg5 }
  hl["@org.keyword.todo"] = { fg = c.red, bold = true }
  hl["@org.keyword.done"] = { fg = c.green, bold = true }
  hl["@org.priority.highest"] = { fg = c.red, bold = true }
  hl["@org.priority.high"] = { fg = c.orange }
  hl["@org.priority.default"] = { fg = c.fg3 }
  hl["@org.priority.low"] = muted
  hl["@org.priority.lowest"] = muted
  hl["@org.timestamp.active"] = { fg = c.blue }
  hl["@org.timestamp.inactive"] = { fg = c.fg4, italic = true }
  hl["@org.bullet"] = { fg = c.fg3 }
  hl["@org.checkbox"] = { fg = c.fg3 }
  hl["@org.checkbox.checked"] = { fg = c.green }
  hl["@org.checkbox.halfchecked"] = { fg = c.yellow }
  hl["@org.properties"] = { fg = c.fg3 }
  hl["@org.properties.name"] = { fg = c.fg3, italic = true }
  hl["@org.drawer"] = muted
  hl["@org.tag"] = { fg = c.fg3, italic = true }
  hl["@org.plan"] = { fg = c.fg3 }
  hl["@org.comment"] = { link = "Comment" }
  hl["@org.directive"] = { fg = c.fg3 }
  hl["@org.block"] = { fg = c.fg2 }
  hl["@org.code"] = { fg = c.fg2, bg = c.bg_dim }
  hl["@org.verbatim"] = { fg = c.fg2, bg = c.bg_dim }
  hl["@org.latex"] = { fg = syn.special }
  hl["@org.footnote"] = { fg = c.fg3 }
  hl["@org.table.delimiter"] = muted
  hl["@org.table.heading"] = { fg = c.fg_strong, bold = true }
  hl["@org.agenda.deadline"] = { fg = c.red }
  hl["@org.agenda.deadline.upcoming"] = { fg = c.yellow }
  hl["@org.agenda.scheduled"] = { fg = c.green }
  hl["@org.agenda.scheduled_past"] = { fg = c.orange }
  hl["@org.agenda.today"] = { fg = c.fg_strong, bold = true, underline = true }
  hl["@org.agenda.weekend"] = { fg = c.fg3 }
  hl["@org.agenda.header"] = title
  hl["@org.agenda.separator"] = { fg = c.fg5 }
  hl["@org.agenda.tag"] = { fg = c.fg3, italic = true }
  hl["@org.agenda.time_grid"] = muted
  hl.OrgBulletsDash = { fg = c.fg3 }
  hl.OrgBulletsPlus = { fg = c.fg3 }
  hl.OrgBulletsStar = { fg = c.fg3 }

  for i = 1, 6 do
    hl["VimwikiHeader" .. i] = { link = "@markup.heading." .. i }
  end
  hl.VimwikiHeaderChar = { fg = c.fg3 }
  hl.VimwikiLink = { fg = c.blue, underline = true }
  hl.VimwikiList = { fg = c.fg3 }
  hl.VimwikiCode = { link = "@markup.raw" }
  hl.VimwikiPre = { fg = c.fg2 }
  hl.VimwikiBold = { fg = c.fg_strong, bold = true }
  hl.VimwikiItalic = { italic = true }
  hl.VimwikiBoldItalic = { bold = true, italic = true }
  hl.VimwikiDelText = { fg = c.fg4, strikethrough = true }
  hl.VimwikiHR = { fg = c.fg4 }
  hl.VimwikiTag = { fg = c.teal }
  hl.VimwikiMarkers = muted
  hl.VimwikiCheckBoxDone = { fg = c.fg4 }

  -- startify ------------------------------------------------------------------
  hl.StartifyHeader = { fg = c.fg3 }
  hl.StartifySection = title
  hl.StartifyBracket = muted
  hl.StartifyNumber = { fg = c.blue, bold = true }
  hl.StartifyFile = { fg = c.fg }
  hl.StartifyPath = { fg = c.fg3 }
  hl.StartifySlash = muted
  hl.StartifySpecial = { fg = c.fg4, italic = true }
  hl.StartifyFooter = muted
  hl.StartifyVar = { fg = c.fg3 }
  hl.StartifySelect = { link = "Visual" }

  -- lazy.nvim & mason ---------------------------------------------------------
  hl.LazyNormal = float
  hl.LazyH1 = label
  hl.LazyH2 = { fg = c.fg_strong, bold = true }
  hl.LazyButton = { fg = c.fg2, bg = c.bg_dim }
  hl.LazyButtonActive = label
  hl.LazySpecial = { fg = c.blue }
  hl.LazyProgressDone = { fg = c.fg }
  hl.LazyProgressTodo = { fg = c.fg5 }
  hl.LazyProp = { fg = c.fg3 }
  hl.LazyValue = { fg = syn.string }
  hl.LazyDir = { fg = c.fg3 }
  hl.LazyUrl = { fg = c.fg3, underline = true }
  hl.LazyCommit = { fg = c.violet }
  hl.LazyCommitIssue = { fg = c.orange }
  hl.LazyCommitType = { fg = c.fg, bold = true }
  hl.LazyCommitScope = { fg = c.fg2, italic = true }
  hl.LazyDimmed = muted
  hl.LazyComment = { fg = c.comment, italic = true }
  hl.LazyLocal = { fg = c.teal }
  hl.LazyNoCond = { fg = c.red }
  hl.LazyReasonPlugin = { fg = c.fg2 }
  hl.LazyReasonEvent = { fg = c.orange }
  hl.LazyReasonKeys = { fg = c.teal }
  hl.LazyReasonStart = { fg = c.green }
  hl.LazyReasonSource = { fg = c.blue }
  hl.LazyReasonFt = { fg = c.violet }
  hl.LazyReasonCmd = { fg = c.yellow }
  hl.LazyReasonImport = { fg = c.fg }
  hl.LazyReasonRequire = { fg = c.fg2 }
  hl.LazyReasonRuntime = { fg = c.fg3 }
  hl.LazyTaskOutput = { fg = c.fg2 }
  hl.LazyTaskError = { fg = c.red }

  hl.MasonNormal = float
  hl.MasonHeader = label
  hl.MasonHeaderSecondary = { fg = c.bg, bg = c.blue, bold = true }
  hl.MasonHeading = title
  hl.MasonHighlight = { fg = c.blue }
  hl.MasonHighlightBlock = { fg = c.bg, bg = c.blue }
  hl.MasonHighlightBlockBold = { fg = c.bg, bg = c.blue, bold = true }
  hl.MasonHighlightSecondary = { fg = c.yellow }
  hl.MasonHighlightBlockSecondary = { fg = c.bg, bg = c.yellow }
  hl.MasonHighlightBlockBoldSecondary = { fg = c.bg, bg = c.yellow, bold = true }
  hl.MasonMuted = muted
  hl.MasonMutedBlock = { fg = c.fg2, bg = c.bg_deep }
  hl.MasonMutedBlockBold = { fg = c.fg2, bg = c.bg_deep, bold = true }
  hl.MasonError = { fg = c.red }
  hl.MasonWarning = { fg = c.yellow }
  hl.MasonLink = { fg = c.blue, underline = true }

  -- misc ----------------------------------------------------------------------
  hl.BqfPreviewFloat = float
  hl.BqfPreviewBorder = border
  hl.BqfPreviewTitle = title
  hl.BqfPreviewThumb = { bg = c.fg4 }
  hl.BqfPreviewSbar = { bg = c.bg_dim }
  hl.BqfPreviewCursorLine = { bg = c.bg_dim }
  hl.BqfPreviewRange = { link = "Search" }
  hl.BqfPreviewBufLabel = { fg = c.fg3 }
  hl.BqfSign = { fg = c.blue }

  hl.SpectreHeader = { fg = c.fg3 }
  hl.SpectreBody = { fg = c.fg }
  hl.SpectreFile = { fg = c.fg, bold = true }
  hl.SpectreDir = { fg = c.fg3 }
  hl.SpectreSearch = { fg = c.fg, bg = c.red_wash, strikethrough = true }
  hl.SpectreReplace = { fg = c.fg, bg = c.green_wash }
  hl.SpectreBorder = border

  hl.DapBreakpoint = { fg = c.red }
  hl.DapBreakpointCondition = { fg = c.yellow }
  hl.DapBreakpointRejected = muted
  hl.DapLogPoint = { fg = c.blue }
  hl.DapStopped = { fg = c.green }
  hl.DapStoppedLine = { bg = c.green_tint }

  hl.ScrollbarHandle = { bg = c.bg_deep }
  hl.ScrollbarCursorHandle = { bg = c.fg4 }
  hl.ScrollbarSearch = { fg = c.yellow }
  hl.ScrollbarError = { fg = c.red }
  hl.ScrollbarWarn = { fg = c.yellow }
  hl.ScrollbarInfo = { fg = c.blue }
  hl.ScrollbarHint = { fg = c.teal }
  hl.ScrollbarGitAdd = { fg = c.green }
  hl.ScrollbarGitChange = { fg = c.blue }
  hl.ScrollbarGitDelete = { fg = c.red }

  hl.CopilotSuggestion = { fg = c.fg4, italic = true }
  hl.CopilotAnnotation = { fg = c.fg4, italic = true }
end
