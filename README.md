# folio.nvim

An e-ink colour scheme for Neovim. It keeps the page of
[e-ink.nvim](https://github.com/e-ink-colorscheme/e-ink.nvim) unchanged: its
grey paper, its slate, its interface greys, and for every word only greys
from its 16-level ramp. No word gets more contrast than e-ink allows. Within
that range, folio gives each kind of word its own grey, uses bold and italic,
and adds a little colour where it helps you find something.

- **Greyscale is the core; contrast is the highlighter.** The more a word
  matters, the darker its ink (lighter in dark mode).
- **Bold** marks keywords and names where they are defined. Bold strokes
  already read darker, so bold words get lighter ink: weight alone marks
  them and the contrast stays e-ink's. **Italic** marks types, comments and
  `self`/`this`.
- **Colour is rare.** Only literal values (numbers, booleans, `nil`) and
  escapes are coloured, in rose. Strings are a warm, sepia grey: in data
  files they are most of the page, so colouring them would colour the page.
  How much colour there is is one setting, `saturation`, from 0 (grey) to
  1 (neon).
- **Light and dark** follow `'background'`, so `:set background=dark` switches
  live, and lualine follows.

## The ladder

| Words                                   | Style  | Light     | Dark      |
| --------------------------------------- | ------ | --------- | --------- |
| function calls                          |        | `#333333` | `#cccccc` |
| function definitions                    | bold   | `#474747` | `#aeaeae` |
| keywords                                | bold   | `#5e5e5e` | `#9a9a9a` |
| variables, fields, parameters           |        | `#5e5e5e` | `#aeaeae` |
| types, `self`/`this`                    | italic | `#727272` | `#9a9a9a` |
| operators, punctuation, modules         |        | `#868686` | `#868686` |
| comments                                | italic | `#909090` | `#727272` |
| strings                                 |        | `#6e6055` | `#c2ad9a` |
| numbers, booleans, `nil`, escapes       |        | `#b04d78` | `#df84a8` |
| paper                                   |        | `#cccccc` | `#333333` |

Every neutral grey is one of e-ink.nvim's. Strings and colours are shown at
the default `saturation = 0.6`; they are computed in OKLCH, so each hue keeps
its lightness while the saturation changes.

Named constants (`MAX_SIZE`, Lua's `M`) stay grey. Their capitals already
mark them, and colouring them would put pink on every Lua module.

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
  -- How much colour the accents carry: 0 = grey, 1 = neon (the most the
  -- sRGB gamut allows for each hue).
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

  -- a different rose for literal values (its tints follow)
  on_colors = function(c)
    if c.variant == "light" then c.pink = "#a23b72" end
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
`violet`, `pink`) with `_tint`/`_wash` backgrounds, `sepia` (strings), and
`c.variant`.
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
lua/folio/palette.lua         paper, ink ladder, accents, syntax roles
lua/folio/groups/editor.lua   built-in UI
lua/folio/groups/syntax.lua   legacy groups, tree-sitter, LSP tokens
lua/folio/groups/plugins.lua  plugins
lua/folio/terminal.lua        ANSI colours
lua/lualine/themes/folio.lua  lualine
extras/                       terminal themes + generator
```
