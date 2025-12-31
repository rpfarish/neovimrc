# Neovim Configuration

![Dashboard](https://github.com/rpfarish/neovimrc/blob/main/screenshots/dashboard.png)

A practical Neovim setup focused on LSP, fuzzy finding, and efficient editing workflows.

## Supported Languages

Preconfigured with LSP, formatting, and execution support for:

- **Python** - Ruff (linting/formatting), executes with `uv run main.py`
- **Rust** - rust-analyzer, rustfmt, Clippy, executes with `cargo run`
- **JavaScript/TypeScript** - ts_ls, Prettierd, executes with `node`
- **Lua** - lua_ls, Stylua
- **C/C++** - clangd
- **Markdown** - marksman, markdownlint
- **CSS** - cssls, stylelint
- **TOML** - taplo
- **Typst** - typst LSP

Treesitter syntax highlighting for: Bash, Python, Rust, CSS, C/C++, JavaScript, TypeScript, HTML, Lua, Markdown, Vim, and more.

## Requirements

- Neovim 0.11+
- Git
- A Nerd Font (optional, for icons)
- Basic build tools

### Install Dependencies (Arch Linux)

```bash
sudo pacman -Sy --noconfirm --needed gcc make git ripgrep fd unzip neovim python
```

## Installation

```bash
# Backup existing config
mv ~/.config/nvim ~/.config/nvim.bak

# Clone this repository
git clone https://github.com/rpfarish/neovimrc.git ~/.config/nvim

# Start Neovim (plugins install automatically)
nvim
```

## Key Bindings

Leader key: `Space`

### General

| Key           | Action                         |
| ------------- | ------------------------------ |
| `Esc`         | Clear search highlight         |
| `Space /`     | Fuzzy search in current buffer |
| `Space Space` | Switch buffers                 |
| `K`           | LSP hover documentation        |

### Navigation & Movement

| Key     | Action                               |
| ------- | ------------------------------------ |
| `C-d`   | Scroll down and center               |
| `C-u`   | Scroll up and center                 |
| `C-S-j` | Next in quickfix list                |
| `C-S-k` | Previous in quickfix list            |
| `J`     | Join lines (keeping cursor position) |

### Text Editing

| Key       | Action                             |
| --------- | ---------------------------------- |
| `Space p` | Paste without yanking (visual)     |
| `Space d` | Delete to black hole register      |
| `<`       | Indent left and reselect (visual)  |
| `>`       | Indent right and reselect (visual) |

### Harpoon (Quick File Navigation)

| Key       | Action                        |
| --------- | ----------------------------- |
| `Space a` | Add file to Harpoon           |
| `C-e`     | Toggle Harpoon menu           |
| `C-j`     | Jump to Harpoon file 1        |
| `C-k`     | Jump to Harpoon file 2        |
| `C-l`     | Jump to Harpoon file 3        |
| `C-h`     | Jump to Harpoon file 4        |
| `Space j` | Previous file in Harpoon list |
| `Space k` | Next file in Harpoon list     |

### Telescope (Search)

| Key        | Action                     |
| ---------- | -------------------------- |
| `Space pf` | Search project files       |
| `C-p`      | Search git files           |
| `Space sf` | Search files               |
| `Space sg` | Live grep                  |
| `Space sw` | Search current word        |
| `Space sh` | Search help                |
| `Space sk` | Search keymaps             |
| `Space ss` | Select Telescope picker    |
| `Space sd` | Search diagnostics         |
| `Space sr` | Resume last search         |
| `Space s.` | Recent files               |
| `Space s/` | Search in open files       |
| `Space sn` | Search Neovim config files |
| `Space gd` | Grep git diff              |
| `Space l`  | Colorscheme picker         |
| `Space :`  | Command history            |

### LSP

| Key   | Action                |
| ----- | --------------------- |
| `gd`  | Go to definition      |
| `grr` | Find references       |
| `grn` | Rename symbol         |
| `gra` | Code actions          |
| `gri` | Go to implementation  |
| `grt` | Go to type definition |
| `grD` | Go to declaration     |
| `gO`  | Document symbols      |
| `gW`  | Workspace symbols     |

### File Explorer (Oil.nvim)

| Key       | Action                        |
| --------- | ----------------------------- |
| `-`       | Open parent directory         |
| `Space -` | Open parent directory (float) |
| `C-r`     | Refresh Oil (in Oil buffer)   |

### Git (Gitsigns)

| Key        | Action                   |
| ---------- | ------------------------ |
| `]c`       | Next git change          |
| `[c`       | Previous git change      |
| `Space hs` | Stage hunk               |
| `Space hr` | Reset hunk               |
| `Space hS` | Stage buffer             |
| `Space hu` | Undo stage hunk          |
| `Space hR` | Reset buffer             |
| `Space hp` | Preview hunk             |
| `Space hb` | Blame line               |
| `Space hd` | Diff against index       |
| `Space hD` | Diff against last commit |
| `Space tD` | Toggle deleted preview   |

### Dropbar (Breadcrumbs)

| Key       | Action                 |
| --------- | ---------------------- |
| `Space ;` | Pick symbols in winbar |
| `[;`      | Go to context start    |
| `];`      | Select next context    |

### Formatting

| Key       | Action        |
| --------- | ------------- |
| `Space f` | Format buffer |

### Terminal & Execution

| Key        | Action                   |
| ---------- | ------------------------ |
| `F5`       | Run current file         |
| `Space af` | Toggle floating terminal |
| `Esc Esc`  | Exit terminal mode       |

### Diagnostics & Debugging

| Key        | Action                               |
| ---------- | ------------------------------------ |
| `Space q`  | Diagnostics (Trouble)                |
| `Space xX` | Buffer diagnostics (Trouble)         |
| `Space cs` | Symbols (Trouble)                    |
| `Space cl` | LSP definitions/references (Trouble) |
| `Space xL` | Location list (Trouble)              |
| `Space xQ` | Quickfix list (Trouble)              |
| `Space td` | Todo list (Trouble)                  |
| `Space tb` | Todo list current buffer (Trouble)   |

### Utilities

| Key        | Action                 |
| ---------- | ---------------------- |
| `Space u`  | Toggle undo tree       |
| `Space U`  | Toggle undotree layout |
| `Space th` | Toggle inlay hints     |
| `Space tt` | Toggle transparency    |
| `C-f`      | Open tmux-sessionizer  |

### Text Objects (Mini.ai)

Examples: `va)` (select around paren), `yinq` (yank inside next quote), `ci'` (change inside quote), `g[(` (go to left paren)

### Surround (Mini.surround)

Examples: `saiw)` (surround word with paren), `sd'` (delete quotes), `sr)'` (replace paren with quote)

### Move (Mini.move)

| Key           | Action              |
| ------------- | ------------------- |
| `C-A-h/j/k/l` | Move selection/line |

## Main Plugins

- **lazy.nvim** - Plugin manager
- **telescope.nvim** - Fuzzy finder
- **nvim-lspconfig** - LSP support
- **blink.cmp** - Autocompletion
- **conform.nvim** - Code formatting
- **nvim-treesitter** - Syntax highlighting
- **rose-pine** - Colorscheme
- **oil.nvim** - File explorer
- **harpoon** - Quick file navigation
- **mini.nvim** - Text objects, surround, statusline

## Configuration Structure

```
~/.config/nvim/
├── after/
│   └── ftplugin/          # Filetype-specific keymaps
│       ├── javascript.lua
│       ├── python.lua
│       └── rust.lua
├── lua/
│   └── rpfarish/
│       ├── custom/        # Custom modules
│       │   ├── attach.lua
│       │   ├── commands.lua
│       │   └── floterminal.lua
│       ├── lazy/          # Plugin configurations
│       ├── health.lua     # Health check
│       ├── init.lua
│       ├── remap.lua      # Keymaps
│       └── set.lua        # Vim options
├── init.lua
├── lazy-lock.json
└── LICENSE.md
```

## Customization

### Change Colorscheme

Edit the colorscheme line in `lua/plugins/rosepine.lua`:

```lua
vim.cmd("colorscheme rose-pine-moon")
-- Try: rose-pine, rose-pine-dawn
```

### Add LSP Servers

Add to the `servers` table in `lua/plugins/nvim-lsp.lua`:

```lua
local servers = {
  pyright = {},
  your_server = {},
}
```

### Configure Run Commands

Edit `lua/rpfarish/custom/commands.lua` to add commands for different file types:

```lua
-- Example: Add Go support
cmds.go = function()
  return "go run ."
end
```

Press `F5` to run the current file using the configured command.

## Tips

- Use `F5` to quickly run Python (`uv run main.py`), Rust (`cargo run`), or JS/TS files
- Floating terminal opens at 50% height at the bottom of the screen
- Use `Space th` to toggle inlay hints
- Text objects: `va)`, `yi"`, `ci'`
- Surround: `saiw)` (add), `sd'` (delete), `sr)'` (replace)
- Telescope supports multi-select with `Tab`
- `Space tt` toggles background transparency for your terminal

## License

MIT
