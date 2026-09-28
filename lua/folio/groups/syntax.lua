-- Syntax: legacy groups, tree-sitter captures and LSP semantic tokens.
--
-- Code is set like a printed page: one dark ink, with typography for
-- structure —
--   ink, bold        keywords, definitions;
--   ink              variables, fields, calls;
--   ink, cursive     types, self/this;
--   grey             operators, punctuation, modules;
--   pencil, cursive  comments.
-- Two coloured inks: blue-black for strings, red for literal values
-- (numbers, booleans, nil) and escapes.
return function(hl, c, config)
  local s = config.styles
  local syn = c.syntax
  local function with(base, style)
    return vim.tbl_extend("force", base, style or {})
  end

  local keyword = with({ fg = syn.keyword }, s.keywords)
  local definition = with({ fg = syn.definition }, s.definitions)
  local type = with({ fg = syn.type }, s.types)
  local string = with({ fg = syn.string }, s.strings)
  local constant = with({ fg = syn.constant }, s.constants)
  local comment = with({ fg = c.comment }, s.comments)
  local builtin = with({ fg = c.fg2 }, s.builtins)

  -- legacy groups (still used by many filetypes and plugins) --------------
  hl.Comment = comment
  hl.SpecialComment = with({ fg = c.fg3 }, s.comments)
  hl.Constant = constant
  hl.String = string
  hl.Character = string
  hl.Number = constant
  hl.Boolean = constant
  hl.Float = { link = "Number" }
  hl.Identifier = { fg = c.fg }
  hl.Function = definition
  hl.Statement = keyword
  hl.Conditional = keyword
  hl.Repeat = keyword
  hl.Label = keyword
  hl.Keyword = keyword
  hl.Exception = keyword
  hl.Include = keyword
  hl.StorageClass = keyword
  hl.Structure = keyword
  hl.Typedef = keyword
  hl.Operator = { fg = c.fg3 }
  hl.PreProc = { fg = c.fg2 }
  hl.Define = { fg = c.fg2 }
  hl.Macro = { fg = c.fg2 }
  hl.PreCondit = { fg = c.fg2 }
  hl.Type = type
  hl.Special = { fg = c.fg2 }
  hl.SpecialChar = { fg = syn.special }
  hl.Tag = { fg = c.fg_dark, bold = true }
  hl.Delimiter = { fg = c.fg3 }
  hl.Debug = { fg = c.fg2 }
  hl.Underlined = { underline = true }
  hl.Ignore = { fg = c.fg5 }
  hl.Error = { fg = c.red }
  hl.Todo = { fg = c.bg, bg = c.fg2, bold = true }

  -- tree-sitter -------------------------------------------------------------
  hl["@variable"] = { fg = c.fg }
  hl["@variable.builtin"] = builtin
  hl["@variable.parameter"] = with({ fg = c.fg }, s.parameters)
  hl["@variable.parameter.builtin"] = builtin
  hl["@variable.member"] = { fg = c.fg }
  hl["@property"] = { fg = c.fg }

  -- literal values scream; named constants (ALL_CAPS, Lua's `M`) stay ink —
  -- their capitals already mark them
  hl["@constant"] = { fg = c.fg }
  hl["@constant.builtin"] = constant
  hl["@constant.macro"] = { fg = c.fg }
  -- Some/None/Ok/Err are enum variants, not literals (rust-analyzer agrees)
  hl["@constant.builtin.rust"] = { link = "@constant" }

  hl["@module"] = { fg = c.fg3 }
  hl["@module.builtin"] = { fg = c.fg3 }
  hl["@label"] = { fg = c.fg3, italic = true }

  hl["@string"] = string
  hl["@string.documentation"] = comment
  hl["@string.regexp"] = string
  hl["@string.escape"] = { fg = syn.special }
  hl["@string.special"] = string
  hl["@string.special.symbol"] = string
  hl["@string.special.path"] = string
  hl["@string.special.url"] = with(string, { underline = true })
  hl["@character"] = string
  hl["@character.special"] = { fg = c.fg3 } -- wildcards, globs: markers, not literals
  hl["@boolean"] = constant
  hl["@number"] = constant
  hl["@number.float"] = constant

  hl["@type"] = type
  hl["@type.builtin"] = type
  hl["@type.definition"] = definition
  hl["@attribute"] = { fg = c.fg3, italic = true }
  hl["@attribute.builtin"] = { fg = c.fg3, italic = true }

  hl["@function"] = definition
  hl["@function.builtin"] = { fg = syn.call }
  hl["@function.call"] = { fg = syn.call }
  hl["@function.macro"] = { fg = syn.call }
  hl["@function.method"] = definition
  hl["@function.method.call"] = { fg = syn.call }
  hl["@constructor"] = { fg = syn.call }
  hl["@constructor.lua"] = { fg = c.fg3 } -- table braces
  hl["@operator"] = { fg = c.fg3 }

  hl["@keyword"] = keyword
  hl["@keyword.coroutine"] = keyword
  hl["@keyword.function"] = keyword
  hl["@keyword.operator"] = keyword
  hl["@keyword.import"] = keyword
  hl["@keyword.type"] = keyword
  hl["@keyword.modifier"] = keyword
  hl["@keyword.repeat"] = keyword
  hl["@keyword.return"] = keyword
  hl["@keyword.debug"] = keyword
  hl["@keyword.exception"] = keyword
  hl["@keyword.conditional"] = keyword
  hl["@keyword.conditional.ternary"] = { fg = c.fg3 }
  hl["@keyword.directive"] = { fg = c.fg2 }
  hl["@keyword.directive.define"] = { fg = c.fg2 }

  hl["@punctuation"] = { fg = c.fg3 }
  hl["@punctuation.delimiter"] = { fg = c.fg3 }
  hl["@punctuation.bracket"] = { fg = c.fg3 }
  hl["@punctuation.special"] = { fg = c.fg3 } -- ${…}, YAML ---, markdown bars

  hl["@comment"] = comment
  hl["@comment.documentation"] = comment
  hl["@comment.error"] = { fg = c.red, bold = true }
  hl["@comment.warning"] = { fg = c.yellow, bold = true }
  hl["@comment.todo"] = { fg = c.bg, bg = c.fg2, bold = true }
  hl["@comment.note"] = { fg = c.blue, bold = true }

  hl["@markup.strong"] = { fg = c.fg_dark, bold = true }
  hl["@markup.italic"] = { italic = true }
  hl["@markup.strikethrough"] = { strikethrough = true }
  hl["@markup.underline"] = { underline = true }
  hl["@markup.heading"] = { fg = syn.definition, bold = true }
  hl["@markup.heading.1"] = { fg = syn.definition, bold = true }
  hl["@markup.heading.2"] = { fg = syn.definition, bold = true }
  hl["@markup.heading.3"] = { fg = c.fg_dark, bold = true }
  hl["@markup.heading.4"] = { fg = c.fg_dark, bold = true }
  hl["@markup.heading.5"] = { fg = c.fg2, bold = true }
  hl["@markup.heading.6"] = { fg = c.fg2, bold = true }
  hl["@markup.quote"] = { fg = c.fg, italic = true }
  hl["@markup.math"] = string
  hl["@markup.link"] = { fg = c.fg_dark }
  hl["@markup.link.label"] = { fg = c.fg_dark, underline = true }
  hl["@markup.link.url"] = { fg = c.fg3, underline = true }
  hl["@markup.raw"] = { fg = c.fg2, bg = c.bg_dim }
  hl["@markup.raw.block"] = { fg = c.fg2 }
  hl["@markup.list"] = { fg = c.fg3 }
  hl["@markup.list.checked"] = { fg = c.green }
  hl["@markup.list.unchecked"] = { fg = c.fg3 }

  hl["@diff.plus"] = { fg = c.green }
  hl["@diff.minus"] = { fg = c.red }
  hl["@diff.delta"] = { fg = c.blue }

  hl["@tag"] = { fg = c.fg_dark, bold = true }
  hl["@tag.builtin"] = { fg = c.fg_dark, bold = true }
  hl["@tag.attribute"] = { fg = c.fg3, italic = true }
  hl["@tag.delimiter"] = { fg = c.fg3 }

  -- LSP semantic tokens -------------------------------------------------------
  -- Servers tag every call as "function"; only declarations get the
  -- definition style, calls stay ink.
  hl["@lsp.type.function"] = { link = "@function.call" }
  hl["@lsp.type.method"] = { link = "@function.method.call" }
  hl["@lsp.typemod.function.declaration"] = { link = "@function" }
  hl["@lsp.typemod.function.definition"] = { link = "@function" }
  hl["@lsp.typemod.method.declaration"] = { link = "@function.method" }
  hl["@lsp.typemod.method.definition"] = { link = "@function.method" }
  hl["@lsp.typemod.function.defaultLibrary"] = { link = "@function.builtin" }
  hl["@lsp.typemod.method.defaultLibrary"] = { link = "@function.builtin" }
  hl["@lsp.typemod.variable.defaultLibrary"] = { link = "@variable.builtin" }
  for _, kind in ipairs({ "class", "struct", "enum", "interface", "type", "typeAlias", "union" }) do
    hl["@lsp.type." .. kind] = { link = "@type" }
    hl["@lsp.typemod." .. kind .. ".declaration"] = { link = "@type.definition" }
  end
  hl["@lsp.type.typeParameter"] = { link = "@type" }
  hl["@lsp.type.builtinType"] = { link = "@type.builtin" }
  hl["@lsp.type.namespace"] = { link = "@module" }
  hl["@lsp.type.parameter"] = { link = "@variable.parameter" }
  hl["@lsp.type.property"] = { link = "@property" }
  hl["@lsp.type.enumMember"] = { link = "@constant" }
  hl["@lsp.type.const"] = { link = "@constant" }
  hl["@lsp.type.static"] = { link = "@constant" }
  hl["@lsp.type.macro"] = { link = "@function.macro" }
  hl["@lsp.type.decorator"] = { link = "@attribute" }
  hl["@lsp.type.derive"] = { link = "@attribute" }
  hl["@lsp.type.deriveHelper"] = { link = "@attribute" }
  hl["@lsp.type.builtinAttribute"] = { link = "@attribute.builtin" }
  hl["@lsp.type.keyword"] = { link = "@keyword" }
  hl["@lsp.type.modifier"] = { link = "@keyword.modifier" }
  hl["@lsp.type.selfKeyword"] = { link = "@variable.builtin" }
  hl["@lsp.type.selfTypeKeyword"] = { link = "@variable.builtin" }
  hl["@lsp.type.lifetime"] = { link = "@label" }
  hl["@lsp.type.label"] = { link = "@label" }
  hl["@lsp.type.boolean"] = { link = "@boolean" }
  hl["@lsp.type.number"] = { link = "@number" }
  hl["@lsp.type.string"] = { link = "@string" }
  hl["@lsp.type.escapeSequence"] = { link = "@string.escape" }
  hl["@lsp.type.formatSpecifier"] = { link = "@string.special" }
  hl["@lsp.type.regexp"] = { link = "@string.regexp" }
  hl["@lsp.type.operator"] = { link = "@operator" }
  hl["@lsp.type.unresolvedReference"] = { sp = c.red, undercurl = true }
  hl["@lsp.mod.deprecated"] = { strikethrough = true }
  -- let tree-sitter decide: these would otherwise flatten richer captures
  -- (constants, TODO markers inside comments, ...)
  hl["@lsp.type.variable"] = {}
  hl["@lsp.type.comment"] = {}
end
