vim.g.UltiSnipsExpandTrigger="<tab>"
vim.g.UltiSnipsJumpForwardTrigger="<tab>"
vim.g.UltiSnipsJumpBackwardTrigger="<s-tab>"
vim.g.mapleader = ','
vim.g.maplocalleader = ','
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.wo.number = true
local set = vim.opt -- set options
set.tabstop = 2
set.softtabstop = 2
set.shiftwidth = 2
vim.opt.signcolumn = "yes:1"
vim.opt.clipboard = "unnamedplus"
vim.wo.relativenumber = true

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
	
	'quangnguyen30192/cmp-nvim-ultisnips',

	'KeitaNakamura/tex-conceal.vim',

	{ 'rose-pine/neovim',
	name = 'rose-pine',
	config = function()
						vim.cmd('colorscheme rose-pine')
	end},


	{
		'NeogitOrg/neogit',
		config = true
	},

	'nvim-tree/nvim-web-devicons',

	'nvim-lua/plenary.nvim',

	'nvim-tree/nvim-tree.lua',

	'roxma/nvim-yarp',

	'roxma/vim-hug-neovim-rpc',

	--'nvim-treesitter/nvim-treesitter',
	
	-- lazy.nvim
    {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
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
	'andrewradev/switch.vim',
	'tomtom/tcomment_vim',
	'nvim-telescope/telescope.nvim',
	{ 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },

  'nvim-lualine/lualine.nvim',
	{
  "rareitems/anki.nvim",
  -- lazy -- don't lazy it, it tries to be as lazy possible and it needs to add a filetype association
  opts = {
    {
      -- this function will add support for associating '.anki' extension with both 'anki' and 'tex' filetype.
      tex_support = true,
      models = {
        -- Here you specify which notetype should be associated with which deck
        NoteType = "PathToDeck",
        ["Basic"] = "Deck", "Algebraic Geometry",
        ["SuperBasic"] = "Deck::ChildDeck",
      },
    }
  }
},

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
},
defaults = { lazy = true}
})

vim.g['deoplete#enable_at_startup'] = 1
vim.g.UltiSnipsSnippetDirectories={"UltiSnips"}
vim.g.vimtex_view_method = 'zathura'
vim.g.vimtex_quickfix_mode=0
vim.opt.conceallevel=1
vim.opt.spelllang=en_gb
vim.g.tex_conceal='abdmg'
vim.opt.autochdir = true
vim.keymap.set("n", "K", vim.lsp.buf.hover)
vim.keymap.set("n", "gd", vim.lsp.buf.definition)

local api = require "nvim-tree.api"

require'nvim-tree'.setup{
	vim.keymap.set('n', '<localleader>tt',     api.tree.toggle)
}

require'mason'.setup{}
local cmp = require'cmp'
  cmp.setup({
    snippet = {
      expand = function(args)
        vim.fn["UltiSnips#Anon"](args.body)
      end,
    },
    window = {completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
		},
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = false }),
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
			{ name = 'path' },
      { name = 'ultisnips' },
    }, {
      { name = 'buffer' },
    })
  })

  -- Set up lspconfig.
  local capabilities = require('cmp_nvim_lsp').default_capabilities()
  -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
  require('lspconfig')['texlab'].setup {
    capabilities = capabilities
		    -- gd in normal mode will jump to definition
  }

  require('lspconfig')['pyright'].setup {
		capabilities = capabilities
  }

	require('lspconfig')['ltex'].setup {
		capabilities = capabilities
  }

  require('lspconfig')['lua_ls'].setup {
    capabilities = capabilities
  }
	local function on_attach(_, bufnr)
    local function cmd(mode, lhs, rhs)
      vim.keymap.set(mode, lhs, rhs, { noremap = true, buffer = true })
    end

    -- Autocomplete using the Lean language server
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')



    -- <leader>n will jump to the next Lean line with a diagnostic message on it
    -- <leader>N will jump backwards
    cmd('n', '<leader>n', function() vim.diagnostic.goto_next{popup_opts = {show_header = false}} end)
    cmd('n', '<leader>N', function() vim.diagnostic.goto_prev{popup_opts = {show_header = false}} end)

    -- <leader>K will show all diagnostics for the current line in a popup window
    cmd('n', '<leader>K', function() vim.diagnostic.open_float(0, { scope = "line", header = false, focus = false }) end)

    -- <leader>q will load all errors in the current lean file into the location list
    -- (and then will open the location list)
    -- see :h location-list if you don't generally use it in other vim contexts
    cmd('n', '<leader>q', vim.diagnostic.setloclist)
end

-- Enable lean.nvim, and enable abbreviations and mappings
require('lean').setup{
    abbreviations = { builtin = true },
    lsp = { on_attach = on_attach },
    lsp3 = { on_attach = on_attach },
    mappings = true,
}




	vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    underline = true,
    virtual_text = { spacing = 4 },
    update_in_insert = true,
  })

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

require('telescope').load_extension('fzf')
require('lualine').setup()

