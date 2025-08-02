return {
    -- Harpoon Prime
    {
        'ThePrimeagen/harpoon',
        config = function()
            local opts = { noremap = true, silent = true }
            local term_opts = { silent = true }
            local keymap = vim.api.nvim_set_keymap
            -- harpoon
            keymap('n', '<leader>g', ":lua require('harpoon.mark').add_file()<CR>", opts)
            keymap('n', '<C-e>', ":lua require('harpoon.ui').toggle_quick_menu()<CR>", opts)

            keymap('n', '<C-h>', ":lua require('harpoon.ui').nav_file(1)<CR>", opts)
            keymap('n', '<C-j>', ":lua require('harpoon.ui').nav_file(2)<CR>", opts)
            keymap('n', '<C-k>', ":lua require('harpoon.ui').nav_file(3)<CR>", opts)
            keymap('n', '<C-l>', ":lua require('harpoon.ui').nav_file(4)<CR>", opts)
        end,
    },
}
