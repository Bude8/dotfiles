-----------------------------------------------------------
-- Plugin manager configuration file
-----------------------------------------------------------

-- Plugin manager: packer.nvim
-- url: https://github.com/wbthomason/packer.nvim

-- For information about installed plugins see the README:
-- neovim-lua/README.md
-- https://github.com/brainfucksec/neovim-lua#readme


-- Automatically install packer
local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({
    'git',
    'clone',
    '--depth',
    '1',
    'https://github.com/wbthomason/packer.nvim',
    install_path
  })
  vim.o.runtimepath = vim.fn.stdpath('data') .. '/site/pack/*/start/*,' .. vim.o.runtimepath
end

-- Autocommand that reloads neovim whenever you save the packer_init.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost packer_init.lua source <afile> | PackerSync
  augroup end
]]

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, 'packer')
if not status_ok then
  return
end

-- Install plugins
return packer.startup(function(use)
  -- Add your plugins here:
  use 'wbthomason/packer.nvim' -- packer can manage itself

  -- File explorer
  use 'kyazdani42/nvim-tree.lua'

  -- Indent line
  use 'lukas-reineke/indent-blankline.nvim'

  -- Autopair
  use {
    'windwp/nvim-autopairs',
    config = function()
      require('nvim-autopairs').setup{}
    end
  }

  -- Icons
  use 'kyazdani42/nvim-web-devicons'

  -- Tag viewer
  use 'preservim/tagbar'

  -- -- Treesitter interface
  use 'nvim-treesitter/nvim-treesitter'
  use 'nvim-treesitter/nvim-treesitter-context'

  -- LSP
  use {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "neovim/nvim-lspconfig",
  }

  -- Autocomplete
  use {
    'hrsh7th/nvim-cmp',
    requires = {
      'L3MON4D3/LuaSnip',
      'rafamadriz/friendly-snippets',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-buffer',
      'saadparwaiz1/cmp_luasnip',
    },
  }

  -- Statusline
  use {
    'feline-nvim/feline.nvim',
    requires = {
      'kyazdani42/nvim-web-devicons',
      'lewis6991/gitsigns.nvim',
      'folke/tokyonight.nvim'
    },
    config = function()
      require('plugins.feline').setup()
    end
  }

  -- git labels
  use {
    'lewis6991/gitsigns.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('gitsigns').setup{}
    end
  }

  -- Colour schemes
  use 'folke/tokyonight.nvim'

  -- FZF
  use 'junegunn/fzf'
  use 'junegunn/fzf.vim'

  -- -- Telescope
  -- use {
  --   'nvim-telescope/telescope.nvim', tag = '0.1.1',
  -- -- or                            , branch = '0.1.x',
  --   requires = { {'nvim-lua/plenary.nvim'} }
  -- }

  -- use { 'ibhagwan/fzf-lua',
  --   -- optional for icon support
  --   requires = { 'nvim-tree/nvim-web-devicons' }
  -- }

  -- nvim-surround
  use({
      "kylechui/nvim-surround",
      tag = "*", -- Use for stability; omit to use `main` branch for the latest features
      config = function()
          require("nvim-surround").setup({
              -- Configuration here, or leave empty to use defaults
          })
      end
  })

  -- tpope
  -- use 'tpope/vim-commentary'
  use 'tpope/vim-fugitive'
  use 'tpope/vim-unimpaired'

  -- Comment.nvim
  use {
      'numToStr/Comment.nvim',
      config = function()
          require('Comment').setup()
      end
  }
  -- vim-rooter
  -- Would like to swap to a lua version for FZF and rooter but these work better for now
  use 'airblade/vim-rooter'

  -- -- nvim-rooter.lua
  -- use {
  --     'notjedi/nvim-rooter.lua',
  --     config = function() require'nvim-rooter'.setup() end
  -- }

  -- -- project
  -- use {
  --   "ahmedkhalf/project.nvim",
  --   config = function()
  --     require("project_nvim").setup {
  --       -- your configuration comes here
  --       -- or leave it empty to use the default settings
  --       -- refer to the configuration section below
  --     }
  --   end
  -- }

  -- bufferline
  use {'akinsho/bufferline.nvim', tag = "v2.*", requires = 'kyazdani42/nvim-web-devicons'}

  -- nvim-ts-autotag
  use 'windwp/nvim-ts-autotag'

  -- go
  use 'ray-x/go.nvim'
  use 'ray-x/guihua.lua' -- recommanded if need floating window support

  -- -- rust
  -- use 'rust-lang/rust.vim'
  -- use 'rhysd/rust-doc.vim'
  -- use 'simrat39/rust-tools.nvim'

  -- Debugging
  use 'nvim-lua/plenary.nvim'
  use 'mfussenegger/nvim-dap'

  -- Undotree
  use 'mbbill/undotree'

  -- Multi
  use 'mg979/vim-visual-multi'

  -- -- GitHub Copilot
  -- use {
  --   "zbirenbaum/copilot.lua",
  --   cmd = "Copilot",
  --   event = "InsertEnter",
  --   config = function()
  --     require("copilot").setup({
  --       panel = { auto_refresh = true },
  --       suggestion = { auto_trigger = true },
  --       filetypes = { yaml = true }
  --     })
  --   end,
  -- }

  -- use {
  --   "zbirenbaum/copilot-cmp",
  --   after = { "copilot.lua" },
  --   config = function ()
  --     require("copilot_cmp").setup()
  --   end
  -- }

  -- todo-comments
  use {
    "folke/todo-comments.nvim",
    requires = "nvim-lua/plenary.nvim",
    config = function()
      require("todo-comments").setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    end
  }

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)
