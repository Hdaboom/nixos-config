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
    ];

    plugins = with pkgs.vimPlugins; [
      # MANDATORY DEPENDENCY
      plenary-nvim # This fixes the 'plenary.strings' not found error

      # Themes
      catppuccin-nvim
      tokyonight-nvim
      nightfox-nvim

      # UI
      lualine-nvim
      nvim-web-devicons
      bufferline-nvim
      nvim-tree-lua
      telescope-nvim

      # Tools & Coding
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
      -- 1. THEME PERSISTENCE
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

      -- 2. SETUP BOOTSTRAP
      require('nvim-autopairs').setup({ check_ts = true })
      require('gitsigns').setup()
      require('nvim-tree').setup{}
      require('bufferline').setup{ options = { mode = "buffers" } }
      require('lualine').setup({ options = { theme = 'auto' } })
      require("toggleterm").setup({
        open_mapping = [[<C-\>]],
        direction = 'horizontal',
        size = 15
      })

      -- Apply theme
      pcall(vim.cmd.colorscheme, load_theme())

      -- 3. TOOLS (Lazygit)
      local Terminal = require('toggleterm.terminal').Terminal
      local lg_term = Terminal:new({ 
        cmd = "lazygit", 
        direction = "float",
        on_close = function() vim.cmd("checktime") end,
      })

      -- 4. KEYBINDINGS

      -- SELECT ALL (Native VimScript version - most reliable)
      -- This saves view, selects all, and restores view in one atomic step
      vim.keymap.set({'n', 'i', 'v'}, '<C-a>', function()
        vim.cmd([[
          let save_view = winsaveview()
          normal! ggVG
          call winrestview(save_view)
        ]])
      end, { desc = "Select All" })

      -- LAZYGIT (Space + g)
      vim.keymap.set('n', '<leader>g', function() lg_term:toggle() end)

      -- TELESCOPE (Now works because plenary is installed)
      vim.keymap.set('n', '<C-p>', function() require('telescope.builtin').find_files() end)
      vim.keymap.set('n', '<C-S-f>', function() require('telescope.builtin').live_grep() end)
      vim.keymap.set('n', '<C-S-p>', function() require('telescope.builtin').keymaps() end)

      -- THEME PICKER
      vim.keymap.set('n', '<leader>th', function()
        require('telescope.builtin').colorscheme({
          enable_preview = true,
          attach_mappings = function(prompt_bufnr, _)
            local actions = require("telescope.actions")
            local action_state = require("telescope.actions.state")
            actions.select_default:replace(function()
              local selection = action_state.get_selected_entry()
              actions.close(prompt_bufnr)
              vim.cmd.colorscheme(selection.value)
              save_theme(selection.value)
            end)
            return true
          end,
        })
      end)

      -- 5. LSP & AUTOCOMPLETE
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

      -- 6. GENERAL SETTINGS
      vim.opt.clipboard = "unnamedplus"
      vim.opt.number = true
      vim.opt.relativenumber = true
      vim.opt.mouse = 'a'
      vim.opt.termguicolors = true
      vim.g.mapleader = " "

      -- Navigation
      vim.keymap.set('n', '<leader>m', ':MinimapToggle<CR>')
      vim.keymap.set('n', '<C-b>', ':NvimTreeToggle<CR>')
      vim.keymap.set('n', 'H', ':BufferLineCyclePrev<CR>')
      vim.keymap.set('n', 'L', ':BufferLineCycleNext<CR>')
      vim.keymap.set('n', '<C-t>', ':enew<CR>')
      vim.keymap.set('n', '<C-w>', ':bdelete<CR>')

      -- Format on Save
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*",
        callback = function() vim.lsp.buf.format { async = false } end,
      })
    '';
  };
}
