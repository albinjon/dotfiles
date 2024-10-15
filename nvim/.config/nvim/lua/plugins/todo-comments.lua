-- Highlight todo, notes, etc in comments
return {
    {
        'folke/todo-comments.nvim',
        event = 'BufReadPre',
        dependencies = { 'nvim-lua/plenary.nvim' },
        opts = { signs = false },
    },
}
