vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.cmd("set number")         
vim.cmd("set relativenumber") 
vim.g.mapleader = " "


local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
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

local opts = {}

local plugins = {
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  {
    'nvim-telescope/telescope.nvim', tag = '0.1.6',
    dependencies = { 'nvim-lua/plenary.nvim' }
  },
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    }
  },
  {
    "lervag/vimtex",
    lazy = false,
    init = function()
      vim.g.vimtex_view_method = 'zathura'
      vim.g.vimtex_compiler_method = 'latexmk'
      vim.api.nvim_set_keymap('n', '<F5>', ':VimtexCompile<CR>', { noremap = true, silent = true })
    end
  },
  {
    'glepnir/dashboard-nvim',
    event = 'VimEnter',
    dependencies = {
      { 'MaximilianLloyd/ascii.nvim', dependencies = { 'MunifTanjim/nui.nvim' } },
    },
    config = function()
      require('dashboard').setup({
        header = [[
          _
        | |   _
      __| | _| |_ __  _ __ ___  ___
     / _` |/ / | '_ \| '__/ _ \/ __|
    | (_| | | | | | | | | |  __/\__ \
     \__,_|_| |_| |_|_|  \___||___/
        ]],
        config = {
          center = {
            { icon = '  ', desc = 'Recently latest session    ', action = 'SessionLoad' },
            { icon = '  ', desc = 'Recently opened files       ', action = 'DashboardFindHistory' },
            { icon = '  ', desc = 'Find File                   ', action = 'Telescope find_files' },
            { icon = '  ', desc = 'File Browser                ', action = 'Telescope file_browser' },
            { icon = '  ', desc = 'Find word                   ', action = 'Telescope live_grep' },
            { icon = '  ', desc = 'Open Personal dotfiles      ', action = 'Telescope dotfiles path=' .. os.getenv('HOME') .. '/.dotfiles' },
          },
          footer = {"Have a nice day!"}
        }
      })
    end,
  },
  -- Adicionando o plugin nvim-compe com suporte a snippets usando vim-vsnip
  {
    "hrsh7th/nvim-compe",
    event = "InsertEnter",
    config = function()
      require("compe").setup({
        enabled = true,
        autocomplete = true,
        source = {
          path = true,
          buffer = true,
          nvim_lsp = true,
          nvim_lua = true,
          vsnip = true, -- Adiciona suporte a snippets do vim-vsnip
        },
      })
    end,
    requires = {{"hrsh7th/vim-vsnip"}}, -- Requisito para suporte a snippets
  },
}

require("lazy").setup(plugins, opts)

local builtin = require("telescope.builtin")
vim.keymap.set('n', '<C-p>', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})

vim.keymap.set('n', '<C-n>', ':Neotree filesystem reveal left<CR>')

require("catppuccin").setup()
vim.cmd.colorscheme "catppuccin"

local configs = require("nvim-treesitter.configs")
configs.setup({
  ensure_installed = {"lua", "javascript", "c"},
  highlight = { enable = true },
  indent = { enable = true },
})
