{ config, pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;

    extraPackages = with pkgs; [
      code-minimap
      pyright
      nil
      vtsls
      lua-language-server
      wl-clipboard
      xclip
      git
      ripgrep
      lazygit
      xdg-utils # Required for "System Open" functionality
    ];

    plugins = with pkgs.vimPlugins; [
      plenary-nvim
      catppuccin-nvim
      tokyonight-nvim
      nightfox-nvim
      lualine-nvim
      nvim-web-devicons # Provides the icons
      bufferline-nvim
      nvim-tree-lua
      telescope-nvim
      nvim-lspconfig
      nvim-cmp
      cmp-nvim-lsp
      luasnip
      cmp_luasnip
      nvim-autopairs
      minimap-vim
      gitsigns-nvim
      undotree
      toggleterm-nvim
      (nvim-treesitter.withPlugins (p: [
        p.lua
        p.python
        p.javascript
        p.nix
      ]))
    ];

    extraLuaConfig = ''
      -- 1. GLOBAL SETTINGS
      vim.g.mapleader = " "
      vim.opt.clipboard = "unnamedplus"
      vim.opt.termguicolors = true
      vim.opt.number = true
      vim.opt.mouse = 'a'

      -- 2. THEME PERSISTENCE
      local theme_cache = vim.fn.stdpath("data") .. "/last_theme.txt"
      local function save_theme(theme)
        local f = io.open(theme_cache, "w")
        if f then f:write(theme) f:close() end
      end
      local function load_theme()
        local f = io.open(theme_cache, "r")
        if f then
          local theme = f:read("*all"):gsub("%s+", "")
          f:close()
          return theme
        end
        return "catppuccin"
      end

      -- 3. NVIM-TREE SETUP (Icons + Media Opening)
      require('nvim-tree').setup({
        renderer = {
          icons = {
            show = {
              file = true,
              folder = true,
              folder_arrow = true,
              git = true,
            },
          },
        },
        view = {
          width = 35,
        },
        -- Open media files with system default app
        on_attach = function(bufnr)
          local api = require('nvim-tree.api')
          local function opts(desc)
            return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
          end

          -- Default mappings
          api.config.mappings.default_on_attach(bufnr)

          -- Custom: Open with System App (Double click or 'o')
          vim.keymap.set('n', 'o', function()
            local node = api.tree.get_node_under_cursor()
            local extension = vim.fn.fnamemodify(node.absolute_path, ":e")
            local media_exts = { "jpg", "jpeg", "png", "gif", "mp4", "pdf", "mp3", "mkv" }
            
            if vim.tbl_contains(media_exts, extension:lower()) then
              vim.fn.jobstart({ "xdg-open", node.absolute_path }, { detach = true })
            else
              api.node.open.edit()
            end
          end, opts('Open File or System Media'))
        end
      })

      -- Smart Quit: Close Neovim if only NvimTree is left
      vim.api.nvim_create_autocmd("BufEnter", {
        group = vim.api.nvim_create_augroup("NvimTreeSmartQuit", { clear = true }),
        callback = function()
          local layout = vim.api.nvim_call_function("winlayout", {})
          if layout[1] == "leaf" and vim.bo[vim.api.nvim_win_get_buf(layout[2])].ft == "NvimTree" and #vim.api.nvim_list_wins() == 1 then
            vim.cmd("confirm quit")
          end
        end
      })

      -- 4. BOOTSTRAP PLUGINS
      require('nvim-autopairs').setup({ check_ts = true })
      require('gitsigns').setup()
      require('bufferline').setup{ options = { mode = "buffers" } }
      require('lualine').setup({ options = { theme = 'auto' } })
      require("toggleterm").setup({ open_mapping = [[<C-\>]], direction = 'horizontal', size = 15 })
      pcall(vim.cmd.colorscheme, load_theme())

      -- 5. TOOLS & KEYBINDINGS
      local opts = { noremap = true, silent = true, nowait = true }

      -- Lazygit
      local lg_term = require('toggleterm.terminal').Terminal:new({ cmd = "lazygit", direction = "float" })
      vim.keymap.set('n', '<leader>g', function() lg_term:toggle() end, opts)

      -- Select All
      vim.keymap.set({'n', 'i', 'v'}, '<C-a>', '<Esc>ggVG', opts)

      -- Command Palette (Alt + x)
      vim.keymap.set('n', '<M-x>', function() require('telescope.builtin').keymaps() end, opts)

      -- Search
      vim.keymap.set('n', '<C-p>', function() require('telescope.builtin').find_files() end, opts)
      vim.keymap.set('n', '<C-f>', function() require('telescope.builtin').live_grep() end, opts)

      -- Sidebar Toggle
      vim.keymap.set('n', '<C-b>', ':NvimTreeToggle<CR>', opts)

      -- 6. LSP (Neovim 0.11+)
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      local servers = { 'pyright', 'nil_ls', 'vtsls', 'lua_ls' }
      for _, lsp in ipairs(servers) do
        if vim.lsp.config then
          vim.lsp.config(lsp, { capabilities = capabilities })
          vim.lsp.enable(lsp)
        else
          require('lspconfig')[lsp].setup { capabilities = capabilities }
        end
      end

      -- Nav Binds
      vim.keymap.set('n', 'H', ':BufferLineCyclePrev<CR>', opts)
      vim.keymap.set('n', 'L', ':BufferLineCycleNext<CR>', opts)
      vim.keymap.set('n', '<C-t>', ':enew<CR>', opts)
      vim.keymap.set('n', '<C-w>', ':bdelete<CR>', opts)

      -- Format on Save
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*",
        callback = function() vim.lsp.buf.format { async = false } end,
      })
    '';
  };
}
