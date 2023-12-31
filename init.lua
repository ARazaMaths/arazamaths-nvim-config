vim.g.mapleader = ','
vim.g.maplocalleader = ','
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.wo.number = true
local set = vim.opt -- set options
set.tabstop = 2
set.softtabstop = 2
set.shiftwidth = 2

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
vim.fn.system({
		"git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
	
require("lazy").setup({
	'lervag/vimtex',
	
	'SirVer/ultisnips',
	
	'honza/vim-snippets',

	{
    -- Theme inspired by Atom
    'rose-pine/neovim',
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'rose-pine'
    end,
  },
	
	{
		'NeogitOrg/neogit',
		config = true
	},

	'nvim-tree/nvim-web-devicons',

	'nvim-lua/plenary.nvim',

	'nvim-tree/nvim-tree.lua',
  
---	'Shougo/deoplete.nvim',
  
	'roxma/nvim-yarp',
  
	'roxma/vim-hug-neovim-rpc',

	'nvim-treesitter/nvim-treesitter',

    {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
	},
	},
	{
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
		-- Automatically install LSPs to stdpath for neovim
		'williamboman/mason.nvim',
		'williamboman/mason-lspconfig.nvim',
    },
	},
	'hrsh7th/nvim-cmp',
	'hrsh7th/cmp-nvim-lsp',
	'hrsh7th/cmp-buffer',
	'hrsh7th/vim-vsnip',
	'andrewradev/switch.vim',
	'tomtom/tcomment_vim',
	'nvim-telescope/telescope.nvim',

	{
  'Julian/lean.nvim',
  event = { 'BufReadPre *.lean', 'BufNewFile *.lean' },

  dependencies = {
    'neovim/nvim-lspconfig',
    'nvim-lua/plenary.nvim',
    -- you also will likely want nvim-cmp or some completion engine
  },

  -- see details below for full configuration options
  opts = {
    lsp = {
      on_attach = on_attach,
    },
    mappings = true,
		
  }
}

})

vim.g.UltiSnipsExpandTrigger="<tab>"
vim.g.UltiSnipsJumpForwardTrigger="<c-b>"
vim.g.UltiSnipsJumpBackwardTrigger="<c-z>"
vim.g['deoplete#enable_at_startup'] = 1
vim.g.vimtex_view_method = 'zathura'
vim.opt.autochdir = true
vim.keymap.set("n", "K", vim.lsp.buf.hover)

require'nvim-tree'.setup{}
require'mason'.setup{}
local cmp = require'cmp'

  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
        --vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
      end,
    },
    window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' }, -- For vsnip users.
      -- { name = 'luasnip' }, -- For luasnip users.
      { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
    }, {
      { name = 'buffer' },
    })
  })

  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
    }, {
      { name = 'buffer' },
    })
  })

  -- Set up lspconfig.
  local capabilities = require('cmp_nvim_lsp').default_capabilities()
  -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
  require('lspconfig')['texlab'].setup {
    capabilities = capabilities
  }

  require('lspconfig')['ltex'].setup {
    capabilities = capabilities
  }

  require('lspconfig')['lua_ls'].setup {
    capabilities = capabilities
  }

