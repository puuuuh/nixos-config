local execute =  vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data')..'/site/pack/packer/opt/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  execute('!git clone https://github.com/wbthomason/packer.nvim '..install_path)
  execute 'packadd packer.nvim'
end

vim.cmd [[packadd packer.nvim]]

vim.cmd 'autocmd BufWritePost plugins.lua PackerCompile' -- Auto compile when there are changes in plugins.lua

return require('packer').startup(function()
    use {'wbthomason/packer.nvim', opt = true}
    use {'lewis6991/impatient.nvim', rocks = 'mpack'}
    -- LSP
    use 'neovim/nvim-lspconfig'
    use 'onsails/lspkind-nvim'
    use 'nvim-lua/lsp_extensions.nvim'

    -- Autocomplete
    use {
        "hrsh7th/nvim-cmp",
        requires = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-nvim-lua",
            "hrsh7th/vim-vsnip",
            "hrsh7th/cmp-vsnip",
            "hrsh7th/cmp-buffer",
        }
    }
    use 'L3MON4D3/LuaSnip'

	--fzf
	use {'junegunn/fzf', dir = '~/.fzf', run = './install --all' }
	use {'junegunn/fzf.vim'}

    -- Other
    use 'folke/tokyonight.nvim'
 
    use 'airblade/vim-rooter'
    use 'puuuuh/rust.vim'
    use 'puremourning/vimspector'

    -- TS react
    use 'pangloss/vim-javascript'
    use 'leafgarland/typescript-vim'
    use 'peitalin/vim-jsx-typescript'
    use 'jparise/vim-graphql'

    -- highlight
    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'} 

	use {
	   'glepnir/galaxyline.nvim',
		branch = 'main',
		config = function() require'galaxyline/my' end,
		requires = {'kyazdani42/nvim-web-devicons', opt = true}
    }
    use 'nvim-lua/lsp-status.nvim'
    use 'Shougo/echodoc.vim'
    use 'puuuuh/vimspector-rust'

    use {
        "folke/lsp-trouble.nvim",
        requires = "kyazdani42/nvim-web-devicons",
    }

    use 'mboughaba/i3config.vim'

    use 'weirongxu/plantuml-previewer.vim'

    use 'tyru/open-browser.vim'

    use 'aklt/plantuml-syntax'

    use 'fatih/vim-go'

    use 'nvim-lua/plenary.nvim'
    use 'nvim-telescope/telescope.nvim'
    use 'nvim-lua/popup.nvim'

    use {
        'kyazdani42/nvim-tree.lua',
        requires = 'kyazdani42/nvim-web-devicons',
        config = function()
            vim.g.nvim_tree_respect_buf_cwd = 1
            require'nvim-tree'.setup({
                update_cwd = true,
                update_focused_file = {
                    enable = true,
                    update_cwd = true
                },
            })
        end
    }
    use {
        "ahmedkhalf/project.nvim",
        config = function()
            require("project_nvim").setup {
                -- your configuration comes here
                -- or leave it empty to use the default settings
                -- refer to the configuration section below
            }
            require('telescope').load_extension('projects')
        end
    }

    use {
        'TimUntersberger/neogit', requires = 'nvim-lua/plenary.nvim',
        config = function ()
            require('neogit').setup {}
        end
    }

    use "lukas-reineke/indent-blankline.nvim"

    use 'easymotion/vim-easymotion'

	-- brackets
	-- use 'windwp/nvim-autopairs'
    -- use 'liuchengxu/vim-which-key'
    -- use 'puremourning/vimspector'

end)
