---@diagnostic disable: undefined-global
-- kitty-scrollback-nvim-kitten-config.lua

-- put your general Neovim configurations here
vim.g.mapleader = " "
vim.g.localleader = ","

vim.opt.relativenumber = true

vim.opt.clipboard = "unnamedplus"

vim.opt.runtimepath:append(vim.fn.stdpath("data") .. "/lazy/kitty-scrollback.nvim") -- lazy.nvim
require("kitty-scrollback").setup({})

-- vim: ts=2 sts=2 sw=2 et
