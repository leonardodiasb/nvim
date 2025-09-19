return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
        "MunifTanjim/nui.nvim",
        -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
    },
    config = function()
        require("neo-tree").setup({
            filesystem = {
                filtered_items = {
                    visible = true, -- Show hidden files
                    hide_dotfiles = false, -- Don't hide dotfiles
                    hide_gitignored = false, -- Don't hide git ignored files
                    hide_hidden = false, -- Don't hide hidden files (Windows)
                },
            },
            window = {
                mappings = {
                    ["l"] = {
                        function(state)
                            local node = state.tree:get_node()
                            if node.type == "directory" then
                                if not node:is_expanded() then
                                    -- If directory is collapsed, expand it
                                    require("neo-tree.sources.filesystem").toggle_directory(state, node)
                                end
                            else
                                -- If it's a file, open it
                                require("neo-tree.sources.filesystem.commands").open(state)
                            end
                        end,
                        desc = "Expand directory or open file",
                    },
                    ["h"] = {
                        function(state)
                            local node = state.tree:get_node()
                            if node.type == "directory" and node:is_expanded() then
                                -- If directory is expanded, collapse it
                                require("neo-tree.sources.filesystem").toggle_directory(state, node)
                            else
                                -- If directory is not expanded or it's a file, go to parent
                                require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
                            end
                        end,
                        desc = "Collapse directory or go to parent",
                    },
                },
            },
        })
        
        -- Keymap to toggle neotree
        vim.keymap.set('n', '<leader>e', ':Neotree toggle<CR>', { desc = 'Toggle Neo-tree' })
    end,
}