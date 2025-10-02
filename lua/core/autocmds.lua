-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- Ensure proper filetype detection for ERB files
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    desc = 'Set filetype for ERB files',
    group = vim.api.nvim_create_augroup('erb-filetype', { clear = true }),
    pattern = { '*.erb', '*.html.erb', '*.css.erb' },
    callback = function()
        vim.bo.filetype = 'eruby'
    end,
})

-- Special handling for JSON.erb files - treat as JSON files for highlighting only
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    desc = 'Treat JSON.erb files as JSON files for syntax highlighting',
    group = vim.api.nvim_create_augroup('json-erb-filetype', { clear = true }),
    pattern = { '*.json.erb' },
    callback = function(ev)
        vim.bo[ev.buf].filetype = 'json'
    end,
})

-- Special handling for JS.erb files - treat as JavaScript with ERB support
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    desc = 'Set filetype for JS ERB files',
    group = vim.api.nvim_create_augroup('js-erb-filetype', { clear = true }),
    pattern = { '*.js.erb' },
    callback = function()
        vim.bo.filetype = 'javascript'
        -- Load ERB highlighting within JavaScript files
        vim.schedule(function()
            vim.cmd('runtime! syntax/eruby.vim')
        end)
    end,
})

-- Custom command to format all ERB files in project
vim.api.nvim_create_user_command('FormatAllERB', function()
    local conform = require('conform')
    local files = vim.fn.glob('**/*.erb', false, true)

    if #files == 0 then
        vim.notify('No ERB files found in project', vim.log.levels.INFO)
        return
    end

    local formatted_count = 0
    for _, file in ipairs(files) do
        -- Skip hidden directories, node_modules, and JSON.erb files
        if not file:match('/%.') and not file:match('node_modules') and not file:match('%.json%.erb$') then
            local bufnr = vim.fn.bufadd(file)
            vim.fn.bufload(bufnr)

            conform.format({
                bufnr = bufnr,
                formatters = { 'erb_format' },
                timeout_ms = 2000,
            }, function(err)
                if not err then
                    vim.api.nvim_buf_call(bufnr, function()
                        vim.cmd('write')
                    end)
                    formatted_count = formatted_count + 1
                    vim.notify(string.format('Formatted %d HTML ERB files (skipped JSON.erb)', formatted_count), vim.log.levels.INFO)
                end
            end)
        end
    end
end, { desc = 'Format all HTML ERB files in project (excludes JSON.erb)' })

vim.api.nvim_create_autocmd('FileType', {
    pattern = 'qf',
    callback = function()
        -- normal mode "dd" deletes current entry
        vim.keymap.set('n', 'dd', function()
            local i = vim.fn.line('.') - 1
            local qf = vim.fn.getqflist()
            table.remove(qf, i + 1)
            vim.fn.setqflist(qf, 'r')
        end, { buffer = true })

        -- visual mode "d" deletes selected entries
        vim.keymap.set('x', 'd', function()
            local start_line = vim.fn.line('v') - 1
            local end_line = vim.fn.line('.') - 1
            if start_line > end_line then
                start_line, end_line = end_line, start_line
            end

            local qf = vim.fn.getqflist()
            for i = end_line, start_line, -1 do
                table.remove(qf, i + 1)
            end
            vim.fn.setqflist(qf, 'r')
        end, { buffer = true })
    end,
})

-- -- [[ Highlight on yank ]]
-- -- See `:help vim.highlight.on_yank()`
-- local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
-- vim.api.nvim_create_autocmd('TextYankPost', {
--   callback = function()
--     vim.highlight.on_yank({higoup = 'IncSearch', timeout = 80})
--   end,
--   group = highlight_group,
--   pattern = '*',
-- })
