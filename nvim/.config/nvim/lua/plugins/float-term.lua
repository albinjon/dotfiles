return {
    'numToStr/FTerm.nvim',
    cmd = 'FTermToggle',
    config = function()
        local fterm = require('FTerm')
        fterm.setup({
            border = 'rounded',
            dimensions = {
                height = 0.9,
                width = 0.9,
            },
        })
        vim.api.nvim_create_user_command('FTermToggle', fterm.toggle, {})
    end,
}
