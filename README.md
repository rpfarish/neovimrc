# Neovim Configuration

![Dashboard](https://github.com/rpfarish/neovimrc/screenshots/rpfarish/dashboard.png)

A practical Neovim setup focused on LSP, fuzzy finding, and efficient editing workflows.

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

| Key           | Action                   |
| ------------- | ------------------------ |
| `Space /`     | Search in current buffer |
| `Space Space` | Switch buffers           |
| `Esc`         | Clear search highlight   |

### Telescope (Search)

| Key        | Action         |
| ---------- | -------------- |
| `Space sf` | Find files     |
| `Space sg` | Live grep      |
| `Space sh` | Search help    |
| `Space sk` | Search keymaps |
| `Space s.` | Recent files   |
| `Space gd` | Grep git diff  |

### LSP

| Key   | Action                |
| ----- | --------------------- |
| `gd`  | Go to definition      |
| `grr` | Find references       |
| `grn` | Rename symbol         |
| `gra` | Code actions          |
| `grt` | Go to type definition |

### Formatting (Includes format on write)

| Key       | Action        |
| --------- | ------------- |
| `Space f` | Format buffer |

### File Navigation

| Key | Action                      |
| --- | --------------------------- |
| `-` | Open parent directory (Oil) |

### Terminal & Execution

| Key        | Action                   |
| ---------- | ------------------------ |
| `F5`       | Run current file         |
| `Space af` | Toggle floating terminal |
| `Esc Esc`  | Exit terminal mode       |

### Other

| Key        | Action                     |
| ---------- | -------------------------- |
| `Space u`  | Toggle undo tree           |
| `Space q`  | Open diagnostics (Trouble) |
| `Space th` | Toggle inlay hints         |
| `Space tt` | Toggle transparency        |

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
