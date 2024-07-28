return {
	'folke/persistence.nvim',
	event = 'BufReadPre',
	opts = {
		options = { 'buffers', 'curdir', 'tabpages', 'winsize', 'help' }, -- sessionoptions used for saving
	},
}
