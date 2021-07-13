--------------------- NEOVIM INIT.LUA CONFIG -------------------
------------------------ by: Dan Menjivar ----------------------

-------------------------- HELPERS -----------------------------
local cmd = vim.cmd -- to execute Vim commands e.g. cmd('pwd')
local fn = vim.fn   -- to call Vim functions e.g. fn.bufnr()
local g = vim.g     -- a table to access global variables
local opt = vim.opt -- to set options

local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then opts = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-------------------------- PLUGINS ------------------------------
cmd 'packadd paq-nvim'                      -- load package manager
local paq = require('paq-nvim').paq         -- convenient alias
paq{'savq/paq-nvim', opt=true}              -- paq-nvim manages itself
paq{'lukas-reineke/indent-blankline.nvim'}  -- display indent lines
paq{'nvim-lua/popup.nvim'}                  -- dep for telescope (1/2)
paq{'nvim-lua/plenary.nvim'}                -- dep for telescope (2/2)
paq{'nvim-telescope/telescope.nvim'}        -- fuzzy finder

-- run ':PaqInstall' to install
-- ':PaqUpdate` to update
-- `:PaqClean` to remove unused ones


-------------------------- MAPPINGS -----------------------------
map('i', 'jj', '<Esc>')         -- Map 'jj' to <Esc> in INSERT

-------------------------- OPTIONS -----------------------------
cmd 'colorscheme desert'        -- Put your favorite colorscheme here
opt.expandtab = true            -- Use spaces instead of tabs
opt.tabstop = 2                 -- Number of spaces tabs count for
opt.softtabstop = 2             -- How many spaces tab moves the cursor
opt.shiftwidth = 2              -- Size of an indent
opt.smartindent = true          -- Inserts indents automatically

opt.number = true               -- Show line numbers
opt.wrap = false		            -- Disable line wrap
opt.termguicolors = true		    -- True color support
opt.incsearch = true
opt.relativenumber = true       -- Relative line numbers
