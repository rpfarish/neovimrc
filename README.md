# NeoRyan: A Modern Neovim Configuration

<div align="center">
  
![NeoRyan](https://img.shields.io/badge/NeoRyan-Modern%20Neovim%20Config-8A2BE2?style=for-the-badge&logo=neovim&logoColor=white)
[![Lua](https://img.shields.io/badge/Made%20with-Lua-2C2D72?style=for-the-badge&logo=lua&logoColor=white)](https://www.lua.org)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)
[![Neovim](https://img.shields.io/badge/Neovim-0.9%2B-57A143?style=for-the-badge&logo=neovim&logoColor=white)](https://neovim.io)

</div>

<div align="center">
<img src="/api/placeholder/800/400" alt="NeoRyan Screenshot">
<p><em>A sleek, fast, and functional Neovim configuration for modern developers</em></p>
</div>

## ✨ Features

- 🚀 **Fast startup** with lazy-loaded plugins
- 🎨 **Tokyo Night** colorscheme for a pleasant coding experience
- 🔍 **Telescope** for fuzzy finding and powerful navigation
- 🧠 **LSP integration** with advanced completions via blink.cmp
- 🔄 **Format on save** with conform.nvim
- 🌳 **Treesitter** for advanced syntax highlighting
- 🖌️ **Git integration** with gitsigns.nvim
- ⚡ **Ergonomic keymaps** for efficient workflow
- 📝 **Todo comments** for better task management

## 📦 Pre-requisites

- Neovim >= 0.9.0
- Git
- A [Nerd Font](https://www.nerdfonts.com/) (optional but recommended)
- `make` (for certain plugins)
- Language servers (automatically installed via Mason)
  
Install dependencies on Arch linux:
``` bash 
sudo pacman -Sy --noconfirm --needed --disable-download-timeout gcc make git ripgrep fd unzip neovim python
```

## 🚀 Installation

```bash
# Backup your existing Neovim configuration if needed
mv ~/.config/nvim ~/.config/nvim.bak

# Clone this repository
git clone https://github.com/rpfarish/neovimrc.git ~/.config/nvim

# Start Neovim - plugins will be installed automatically
nvim
```

## ⌨️ Key Bindings

NeoRyan uses Space as the leader key. Here are some of the most important keymaps:

### General

| Keybinding       | Description                    |
| ---------------- | ------------------------------ |
| `<Space>/`       | Fuzzy search in current buffer |
| `<Space><Space>` | Find existing buffers          |
| `<Esc>`          | Clear search highlighting      |

### Search with Telescope

| Keybinding  | Description         |
| ----------- | ------------------- |
| `<Space>sf` | Search Files        |
| `<Space>sg` | Search by Grep      |
| `<Space>sh` | Search Help         |
| `<Space>sk` | Search Keymaps      |
| `<Space>s.` | Search Recent Files |

### LSP Navigation

| Keybinding | Description                                                          |
| ---------- | -------------------------------------------------------------------- |
| `gd`       | Go to Definition (Overrides default vim gd in favor of lsp aware gd) |
| `grr`      | Find References                                                      |
| `grn`      | Rename                                                               |
| `gra`      | Code Action                                                          |
| `grt`      | Go to Type Definition                                                |

### Window Management

| Keybinding | Description              |
| ---------- | ------------------------ |
| `<C-S-h>`  | Move window to the left  |
| `<C-S-j>`  | Move window down         |
| `<C-S-k>`  | Move window up           |
| `<C-S-l>`  | Move window to the right |

### Formatting

| Keybinding | Description   |
| ---------- | ------------- |
| `<Space>f` | Format buffer |

## 🔌 Included Plugins

NeoRyan includes a carefully curated selection of plugins:

- **[lazy.nvim](https://github.com/folke/lazy.nvim)** - Plugin manager
- **[telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)** - Fuzzy finder
- **[gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)** - Git integration
- **[blink.cmp](https://github.com/saghen/blink.cmp)** - Autocompletion
- **[which-key.nvim](https://github.com/folke/which-key.nvim)** - Keybinding helper
- **[nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)** - Advanced syntax highlighting
- **[conform.nvim](https://github.com/stevearc/conform.nvim)** - Code formatting
- **[tokyonight.nvim](https://github.com/folke/tokyonight.nvim)** - Colorscheme
- **[mini.nvim](https://github.com/echasnovski/mini.nvim)** - Collection of small modules
- **[todo-comments.nvim](https://github.com/folke/todo-comments.nvim)** - Highlight TODO comments
- **[mason.nvim](https://github.com/mason-org/mason.nvim)** - Package manager for LSP servers

## 🛠️ Configuration Structure

```
~/.config/nvim/
├── init.lua                    # Main configuration entry point
├── lua/
│   └── plugins/               # Plugin configurations
└── lazy-lock.json             # Plugin version lock file
```

## 🎨 Customization

### Changing the Colorscheme

Edit the colorscheme section in your configuration:

```lua
-- Try other variants: 'tokyonight-storm', 'tokyonight-moon', 'tokyonight-day'
vim.cmd.colorscheme("tokyonight-night")
```

### Adding New LSP Servers

Add new servers to the `servers` table in the LSP configuration section:

```lua
local servers = {
  pyright = {},
  rust_analyzer = {},  -- Uncomment or add new ones
  -- your_new_server = {},
}
```

## 📋 Tips and Tricks

- Use `<Space>th` to toggle inlay hints when supported by the LSP
- Use Mini.ai for enhanced text objects (try `va)`, `yi"`, etc.)
- Use Mini.surround for surroundings (try `saiw)`, `sd'`, `sr)'`)
- Take advantage of Telescope with `<Space>s` prefixed commands

## 🤝 Contributing

Contributions are welcome! Feel free to submit issues or pull requests.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

---

<div align="center">
  <p>⭐ If you find NeoRyan useful, please consider giving it a star on GitHub! ⭐</p>
  <p>Made with ❤️ by Ryan</p>
</div>
