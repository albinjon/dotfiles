---@diagnostic disable: undefined-global
-- kitty-scrollback-nvim-kitten-config.lua

-- put your general Neovim configurations here
vim.g.mapleader = " "
vim.g.localleader = ","

vim.opt.relativenumber = true

vim.opt.clipboard = "unnamedplus"

-- add kitty-scrollback.nvim to the runtimepath to allow us to require the kitty-scrollback module
-- pick a runtimepath that corresponds with your package manager, if you are not sure leave them all it will not cause any issues
vim.opt.runtimepath:append(vim.fn.stdpath("data") .. "/lazy/kitty-scrollback.nvim") -- lazy.nvim

-- require("lazy").setup({
-- 	{
-- 		"nvim-telescope/telescope.nvim",
-- 		dependencies = {
-- 			"nvim-lua/plenary.nvim",
-- 			"nvim-telescope/telescope-file-browser.nvim",
-- 			{ -- If encountering errors, see telescope-fzf-native README for installation instructions
-- 				"nvim-telescope/telescope-fzf-native.nvim",
--
-- 				-- `build` is used to run some command when the plugin is installed/updated.
-- 				-- This is only run then, not every time Neovim starts up.
-- 				build = "make",
--
-- 				-- `cond` is a condition used to determine whether this plugin should be
-- 				-- installed and loaded.
-- 				cond = function()
-- 					return vim.fn.executable("make") == 1
-- 				end,
-- 			},
-- 			config = function()
-- 				local builtin = require("telescope.builtin")
-- 				vim.keymap.set("n", "<leader>/", function()
-- 					-- You can pass additional configuration to Telescope to change the theme, layout, etc.
-- 					builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
-- 						winblend = 10,
-- 						previewer = false,
-- 					}))
-- 				end, { desc = "[/] Fuzzily search in current buffer" })
-- 			end,
-- 		},
-- 	},
-- })
-- local api = require("kitty-scrollback.api")
-- vim.keymap.set("v", "y", "+y", { desc = "Copy selection" })
require("kitty-scrollback").setup({

	-- put your kitty-scrollback.nvim configurations here
})

-- vim: ts=2 sts=2 sw=2 et
