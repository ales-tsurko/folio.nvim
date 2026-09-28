# folio.nvim

An e-ink colour scheme for Neovim. It is built on the page of
[e-ink.nvim](https://github.com/e-ink-colorscheme/e-ink.nvim): neutral grey
paper, grey ink and grey backgrounds. It adds a real hierarchy of greys,
bold and italic, and a very small amount of neon colour.

- **Greyscale is the core; contrast is the highlighter.** Each kind of word
  has its own grey, and the more a word matters, the stronger its ink.
- **Bold** marks keywords and names where they are defined. **Italic** marks
  types, comments and `self`/`this`.
- **Colour is rare and loud.** Strings are neon orange; numbers, booleans,
  `nil` and escapes are neon pink. Both sit at the most saturated point the
  sRGB gamut allows for their hue. Everything else stays grey.
- **Light and dark** follow `'background'`, so `:set background=dark` switches
  live, and lualine follows.

## The ladder

| Words                                   | Style  | Light     | Dark      |
| --------------------------------------- | ------ | --------- | --------- |
| function calls                          |        | `#0d0d0d` | `#f0f0f0` |
| function definitions                    | bold   | `#0d0d0d` | `#d2d2d2` |
| keywords                                | bold   | `#333333` | `#b1b1b1` |
| variables, fields, parameters           |        | `#505050` | `#adadad` |
| types, `self`/`this`                    | italic | `#666666` | `#9a9a9a` |
| operators, punctuation, modules         |        | `#808080` | `#878787` |
| comments                                | italic | `#969696` | `#787878` |
| strings                                 |        | `#fe5101` | `#ff7024` |
| numbers, booleans, `nil`, escapes       |        | `#ff05a9` | `#ff44b0` |
| paper                                   |        | `#cccccc` | `#3a3a3a` |

Light steps are wider than dark ones: thin dark strokes on a light page blur
together, while light strokes on a dark page stay distinct. On a dark page
bold text blooms, so bold words sit below the plain words next to them.

Named constants (`MAX_SIZE`, Lua's `M`) stay grey. Their capitals already
mark them, and colouring them would put pink on every Lua module.

## Install

With [lazy.nvim](https://github.com/folke/lazy.nvim), from a local checkout:

```lua
{
  dir = "~/path/to/folio.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("folio").setup({})
    vim.cmd.colorscheme("folio")
  end,
}
```

## Options

The defaults:

```lua
require("folio").setup({
  -- Paper brightness: "soft" | "medium" | "hard".
  contrast = "medium",
  -- Leave the background to the terminal.
  transparent = false,
  -- Give unfocused windows a slightly darker paper.
  dim_inactive = false,
  -- Define vim.g.terminal_color_0..15.
  terminal_colors = true,
  -- Pure greyscale syntax: colour only for diagnostics and diffs.
  mono = false,
  -- Font variants per syntax role; any nvim_set_hl() attributes work.
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
  on_colors = nil, -- function(colors)
  on_syntax = nil, -- function(syntax, colors)
  on_highlights = nil, -- function(highlights, colors)
})
```

Call `setup()` before `:colorscheme folio`.

### Recipes

```lua
require("folio").setup({
  -- upright types, and keywords in italic instead of bold
  styles = { types = { italic = false }, keywords = { bold = false, italic = true } },

  -- a different spot colour (tints and terminal colours follow)
  on_colors = function(c)
    if c.variant == "light" then c.orange = "#e54800" end
  end,

  -- give types a colour of their own
  on_syntax = function(syntax, c)
    syntax.type = c.teal
  end,

  -- anything else
  on_highlights = function(hl, c)
    hl.CursorLine = { bg = c.bg_deep }
  end,
})
```

`c` holds the paper (`bg`, `bg_dim`, `bg_deep`, `bg_visual`), the ink ladder
(`fg_strong`, `fg_def`, `fg_dark`, `fg`, `fg2`, `fg3`, `comment`, `fg4`,
`fg5`), the accents (`red`, `orange`, `yellow`, `green`, `teal`, `blue`,
`violet`, `pink`) with `_tint`/`_wash` backgrounds, and `c.variant`.
`syntax` holds the roles `keyword`, `definition`, `call`, `type`, `string`,
`constant` and `special`. `require("folio").colors()` returns the table for
the current background.

## Supported

- **Neovim 0.10+ (tested on 0.12):** every built-in group, including `PmenuMatch`,
  `PmenuBorder`, `ComplHint`, `PreInsert`, `DiffTextAdd`, `OkMsg`,
  `StderrMsg`, snippets, inlay hints and virtual-lines diagnostics.
- **Tree-sitter:** all standard captures. LSP semantic tokens are mapped so
  that only declarations look like definitions; calls stay calls. Includes
  rust-analyzer's extra token types.
- **Plugins:**
  - Completion: nvim-cmp, blink.cmp.
  - Pickers: telescope, fzf-lua, snacks.
  - File trees: neo-tree, nvim-tree, oil.
  - Git: gitsigns, diffview, neogit, git-conflict, fugitive.
  - UI: which-key, noice, nvim-notify, trouble, bufferline, lualine,
    dropbar, incline.
  - Guides: indent-blankline, treesitter-context, twilight.
  - Motion: flash, leap, hop, eyeliner, illuminate.
  - Notes: render-markdown, orgmode (+ org-bullets), vimwiki, startify.
  - Tools: lazy.nvim, mason, nvim-bqf, spectre, nvim-dap, nvim-scrollbar,
    copilot.
  - mini: icons, indentscope, statusline, pick, files, diff, clue,
    hipatterns, starter.
- **lualine:** `theme = "auto"` picks up `folio` automatically.

nvim-web-devicons draws its own colours. For an all-grey page, set
`require("nvim-web-devicons").setup({ color_icons = false })`.

## Terminal themes

`extras/` has matching themes for kitty, WezTerm, Ghostty and Alacritty,
generated from the same palette:

```sh
nvim -l extras/generate.lua
```

- **kitty:** `include extras/kitty/folio-light.conf`
- **WezTerm:** copy `extras/wezterm/folio-light.toml` to
  `~/.config/wezterm/colors/`, then set
  `config.color_scheme = "folio-light"`.
- **Ghostty:** copy `extras/ghostty/folio-light` to `~/.config/ghostty/themes/`,
  then set `theme = folio-light`.
- **Alacritty:** `general.import = ["…/extras/alacritty/folio-light.toml"]`

## Layout

```
colors/folio.lua              :colorscheme entry point
lua/folio/init.lua            setup(), load(), colors()
lua/folio/palette.lua         paper, ink ladder, accents, syntax roles
lua/folio/groups/editor.lua   built-in UI
lua/folio/groups/syntax.lua   legacy groups, tree-sitter, LSP tokens
lua/folio/groups/plugins.lua  plugins
lua/folio/terminal.lua        ANSI colours
lua/lualine/themes/folio.lua  lualine
extras/                       terminal themes + generator
```
