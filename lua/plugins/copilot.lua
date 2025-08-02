return {
    {
        -- Copilot
        'github/copilot.vim',
        config = function()
            vim.g.copilot_filetypes = {
                ['c'] = false,
            }
        end,
    },
}
