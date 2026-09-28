# folio.nvim

A colour scheme for Neovim that looks like a page of e-paper: a matte
mid-grey sheet with a faint cool cast, neither quite light nor quite dark,
printed in dense ink.

- **Code is set like a book.** One dark ink for everything that matters,
  with typography for structure: **bold** keywords and definitions,
  *cursive* types and `self`/`this`, a lighter grey for punctuation. Bold
  words take a slightly lighter shade of ink, since the heavier strokes
  already make them darker on the page.
- **Comments are pencil notes** in the margin: grey and cursive.
- **Two coloured inks**, as on a two-colour print: blue-black for strings
  and a red for literal values (numbers, booleans, `nil`) and escapes.
  The other colours only mark state: diagnostics, diffs, git. How much
  colour there is is one setting, `saturation`, from 0 (grey) to 1 (as
  vivid as the screen allows).
- **The interface is an e-reader's.** Floats get hairline borders and
  inverted title tabs; the selected item in a menu or picker is a solid ink
  bar; text selections are grey bands; search inverts the ink.
- **Light and dark** follow `'background'`, so `:set background=dark` switches
  live, and lualine follows.

The idea of the mid-grey page comes from
[e-ink.nvim](https://github.com/e-ink-colorscheme/e-ink.nvim).

## The page

| Words                                   | Style   | Light     | Dark      |
| --------------------------------------- | ------- | --------- | --------- |
| variables, fields, calls                |         | `#2e2e2e` | `#d3d3d3` |
| function and type definitions           | bold    | `#2e2e2e` | `#d3d3d3` |
| keywords                                | bold    | `#474747` | `#bcbcbc` |
| types, `self`/`this`                    | cursive | `#4f4f4f` | `#b4b4b4` |
| operators, punctuation, modules         |         | `#5e5e5e` | `#a4a4a4` |
| comments                                | cursive | `#767676` | `#979797` |
| strings                                 |         | `#33547e` | `#9abbde` |
| numbers, booleans, `nil`, escapes       |         | `#984041` | `#d78e8d` |
| paper                                   |         | `#cacdce` | `#4b4d4f` |

Colours are shown at the default `saturation = 0.6`. They are computed in
OKLCH, so each keeps its lightness while the saturation changes.

Named constants (`MAX_SIZE`, Lua's `M`) and Rust's `Some`/`None`/`Ok`/`Err`
stay ink: they are names, not literal values.

## Install

With [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  "ales-tsurko/folio.nvim",
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
  -- How much colour the inks carry: 0 = grey, 1 = as vivid as the screen
  -- allows.
  saturation = 0.6,
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
  -- more (or less) colour
  saturation = 0.8,

  -- upright types, and keywords in italic instead of bold
  styles = { types = { italic = false }, keywords = { bold = false, italic = true } },

  -- a different red for literal values (its tints follow)
  on_colors = function(c)
    if c.variant == "light" then c.red = "#8a3a52" end
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

`c` holds the paper (`bg`, `bg_dim`, `bg_deep`, `bg_visual`), the inks
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

[`extras/`](extras) has matching themes for kitty, WezTerm, Ghostty and
Alacritty. With lazy.nvim they are already on disk, under
`~/.local/share/nvim/lazy/folio.nvim/extras/`:

- **kitty:** in `kitty.conf`, add
  `include ~/.local/share/nvim/lazy/folio.nvim/extras/kitty/folio-light.conf`.
- **WezTerm:** copy `extras/wezterm/folio-light.toml` to
  `~/.config/wezterm/colors/`, then set `config.color_scheme = "folio-light"`.
- **Ghostty:** copy `extras/ghostty/folio-light` to `~/.config/ghostty/themes/`,
  then set `theme = folio-light`.
- **Alacritty:** set
  `general.import = ["~/.local/share/nvim/lazy/folio.nvim/extras/alacritty/folio-light.toml"]`.

Swap `light` for `dark` for the dark variant. The files are generated from the
palette. After changing it, regenerate them from the repository root:

```sh
nvim -l extras/generate.lua
```

## Layout

```
colors/folio.lua              :colorscheme entry point
lua/folio/init.lua            setup(), load(), colors()
lua/folio/palette.lua         paper, ink, accents, syntax roles
lua/folio/groups/editor.lua   built-in UI
lua/folio/groups/syntax.lua   legacy groups, tree-sitter, LSP tokens
lua/folio/groups/plugins.lua  plugins
lua/folio/terminal.lua        ANSI colours
lua/lualine/themes/folio.lua  lualine
extras/                       terminal themes + generator
```
