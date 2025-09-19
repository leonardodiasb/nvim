return {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
        'MunifTanjim/nui.nvim',
        -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
    },

    config = function()
        require('neo-tree').setup({
            filesystem = {
                filtered_items = {
                    visible = true, -- Show hidden files
                    hide_dotfiles = false, -- Don't hide dotfiles
                    hide_gitignored = false, -- Don't hide git ignored files
                    hide_hidden = false, -- Don't hide hidden files (Windows)
                },
                follow_current_file = {
                    enabled = true, -- This will find and focus the file in the active buffer every time
                    leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
                },
            },
            window = {
                mappings = {
                    ['l'] = {
                        function(state)
                            local node = state.tree:get_node()
                            if node.type == 'directory' then
                                if not node:is_expanded() then
                                    -- If directory is collapsed, expand it
                                    require('neo-tree.sources.filesystem').toggle_directory(state, node)
                                end
                            else
                                -- If it's a file, open it and close neo-tree
                                require('neo-tree.sources.filesystem.commands').open(state)
                                vim.cmd('Neotree close')
                            end
                        end,
                        desc = 'Expand directory or open file and close neo-tree',
                    },
                    ['<cr>'] = {
                        function(state)
                            local node = state.tree:get_node()
                            if node.type == 'directory' then
                                -- For directories, use default behavior (toggle)
                                require('neo-tree.sources.filesystem').toggle_directory(state, node)
                            else
                                -- If it's a file, open it and close neo-tree
                                require('neo-tree.sources.filesystem.commands').open(state)
                                vim.cmd('Neotree close')
                            end
                        end,
                        desc = 'Open file and close neo-tree, or toggle directory',
                    },
                    ['h'] = {
                        function(state)
                            local node = state.tree:get_node()
                            if node.type == 'directory' and node:is_expanded() then
                                -- If directory is expanded, collapse it
                                require('neo-tree.sources.filesystem').toggle_directory(state, node)
                            else
                                -- If directory is not expanded or it's a file, go to parent
                                require('neo-tree.ui.renderer').focus_node(state, node:get_parent_id())
                            end
                        end,
                        desc = 'Collapse directory or go to parent',
                    },
                },
            },
        })

        -- Smart toggle keymap for neotree
        vim.keymap.set('n', '<leader>e', function()
            -- Check if neo-tree is currently visible
            local manager = require("neo-tree.sources.manager")
            local renderer = require("neo-tree.ui.renderer")
            local state = manager.get_state("filesystem")
            
            if renderer.window_exists(state) then
                -- If neo-tree is open, close it
                vim.cmd('Neotree close')
            else
                -- If neo-tree is closed, open with reveal if we have a file
                local current_file = vim.fn.expand('%:p')
                if current_file ~= '' and vim.bo.buftype == '' then
                    vim.cmd('Neotree reveal')
                else
                    vim.cmd('Neotree show')
                end
            end
        end, { desc = 'Toggle Neo-tree with smart reveal' })
    end,
}

