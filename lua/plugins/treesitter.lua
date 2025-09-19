return {
    { -- Highlight, edit, and navigate code
        'nvim-treesitter/nvim-treesitter',
        dependencies = {
            'nvim-treesitter/nvim-treesitter-textobjects',
            'nvim-treesitter/nvim-treesitter-context',
        },
        config = function()
            require('nvim-treesitter.configs').setup({
                -- Add languages to be installed here that you want installed for treesitter
                ensure_installed = {
                    'c',
                    'cpp',
                    'css',
                    'go',
                    'lua',
                    'html',
                    'python',
                    'ruby',
                    'regex',
                    'rust',
                    'tsx',
                    'javascript',
                    'typescript',
                    'vimdoc',
                    'vim',
                    'bash',
                    'markdown',
                    'markdown_inline',
                    'svelte',
                    'sql',
                    'json',
                    'embedded_template', -- For ERB files
                },

                -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
                auto_install = false,
                -- Install languages synchronously (only applied to `ensure_installed`)
                sync_install = false,
                -- List of parsers to ignore installing
                ignore_install = {},
                -- You can specify additional Treesitter modules here: -- For example: -- playground = {--enable = true,-- },
                modules = {},
                highlight = { enable = true },
                indent = { enable = true },
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = '<c-space>',
                        node_incremental = '<c-space>',
                        scope_incremental = '<c-s>',
                        node_decremental = '<M-space>',
                    },
                },
                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
                        keymaps = {
                            -- You can use the capture groups defined in textobjects.scm
                            ['aa'] = '@parameter.outer',
                            ['ia'] = '@parameter.inner',
                            ['af'] = '@function.outer',
                            ['if'] = '@function.inner',
                            ['ac'] = '@class.outer',
                            ['ic'] = '@class.inner',

                            -- You can use the capture groups defined in textobjects.scm
                            ['a='] = { query = '@assignment.outer', desc = 'Select outer part of an assignment' },
                            ['i='] = { query = '@assignment.inner', desc = 'Select inner part of an assignment' },
                            ['l='] = { query = '@assignment.lhs', desc = 'Select left hand side of an assignment' },
                            ['r='] = { query = '@assignment.rhs', desc = 'Select right hand side of an assignment' },

                            -- works for javascript/typescript files (custom capture I created in after/queries/ecma/textobjects.scm)
                            ['a:'] = { query = '@property.outer', desc = 'Select outer part of an object property' },
                            ['i:'] = { query = '@property.inner', desc = 'Select inner part of an object property' },
                            ['l:'] = { query = '@property.lhs', desc = 'Select left part of an object property' },
                            ['r:'] = { query = '@property.rhs', desc = 'Select right part of an object property' },

                            ['ai'] = { query = '@conditional.outer', desc = 'Select outer part of a conditional' },
                            ['ii'] = { query = '@conditional.inner', desc = 'Select inner part of a conditional' },

                            ['al'] = { query = '@loop.outer', desc = 'Select outer part of a loop' },
                            ['il'] = { query = '@loop.inner', desc = 'Select inner part of a loop' },
                        },
                    },
                    move = {
                        enable = true,
                        set_jumps = true, -- whether to set jumps in the jumplist
                        goto_next_start = {
                            [']f'] = { query = '@call.outer', desc = 'Next function call start' },
                            [']m'] = { query = '@function.outer', desc = 'Next method/function def start' },
                            -- ["]c"] = { query = "@class.outer", desc = "Next class start" },
                            [']i'] = { query = '@conditional.outer', desc = 'Next conditional start' },
                            [']l'] = { query = '@loop.outer', desc = 'Next loop start' },

                            -- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
                            -- Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
                            [']s'] = { query = '@scope', query_group = 'locals', desc = 'Next scope' },
                            [']z'] = { query = '@fold', query_group = 'folds', desc = 'Next fold' },
                        },
                        goto_next_end = {
                            [']F'] = { query = '@call.outer', desc = 'Next function call end' },
                            [']M'] = { query = '@function.outer', desc = 'Next method/function def end' },
                            [']C'] = { query = '@class.outer', desc = 'Next class end' },
                            [']I'] = { query = '@conditional.outer', desc = 'Next conditional end' },
                            [']L'] = { query = '@loop.outer', desc = 'Next loop end' },
                        },
                        goto_previous_start = {
                            ['[f'] = { query = '@call.outer', desc = 'Prev function call start' },
                            ['[m'] = { query = '@function.outer', desc = 'Prev method/function def start' },
                            -- ["[c"] = { query = "@class.outer", desc = "Prev class start" },
                            ['[i'] = { query = '@conditional.outer', desc = 'Prev conditional start' },
                            ['[l'] = { query = '@loop.outer', desc = 'Prev loop start' },
                        },
                        goto_previous_end = {
                            ['[F'] = { query = '@call.outer', desc = 'Prev function call end' },
                            ['[M'] = { query = '@function.outer', desc = 'Prev method/function def end' },
                            ['[C'] = { query = '@class.outer', desc = 'Prev class end' },
                            ['[I'] = { query = '@conditional.outer', desc = 'Prev conditional end' },
                            ['[L'] = { query = '@loop.outer', desc = 'Prev loop end' },
                        },
                    },
                    swap = {
                        enable = true,
                        swap_next = {
                            ['<leader>a'] = '@parameter.inner',
                        },
                        swap_previous = {
                            ['<leader>A'] = '@parameter.inner',
                        },
                    },
                },
            })

            vim.keymap.set('n', '[c', function()
                require('treesitter-context').go_to_context(vim.v.count1)
            end, { silent = true })

            -- Example customization for TreesitterContext
            vim.api.nvim_set_hl(0, 'TreesitterContextBottom', { link = 'CursorLineNr' })

            local ts_repeat_move = require('nvim-treesitter.textobjects.repeatable_move')

            -- vim way: ; goes to the direction you were moving.
            vim.keymap.set({ 'n', 'x', 'o' }, ';', ts_repeat_move.repeat_last_move)
            vim.keymap.set({ 'n', 'x', 'o' }, ',', ts_repeat_move.repeat_last_move_opposite)

            -- Optionally, make builtin f, F, t, T also repeatable with ; and ,
            vim.keymap.set({ 'n', 'x', 'o' }, 'f', ts_repeat_move.builtin_f)
            vim.keymap.set({ 'n', 'x', 'o' }, 'F', ts_repeat_move.builtin_F)
            vim.keymap.set({ 'n', 'x', 'o' }, 't', ts_repeat_move.builtin_t)
            vim.keymap.set({ 'n', 'x', 'o' }, 'T', ts_repeat_move.builtin_T)
        end,

        -- build = ':TSUpdate',
        -- main = 'nvim-treesitter.configs', -- Sets main module to use for opts
        -- -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
        -- opts = {
        --   ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc', 'javascript', 'typescript', 'rust', 'go' },
        --   -- Autoinstall languages that are not installed
        --   auto_install = true,
        --   highlight = {
        --     enable = true,
        --     -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        --     --  If you are experiencing weird indenting issues, add the language to
        --     --  the list of additional_vim_regex_highlighting and disabled languages for indent.
        --     additional_vim_regex_highlighting = { 'ruby' },
        --   },
        --   indent = { enable = true, disable = { 'ruby' } },
        -- },

        -- There are additional nvim-treesitter modules that you can use to interact
        -- with nvim-treesitter. You should go explore a few and see what interests you:
        --
        --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
        --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
        --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
    },
}
