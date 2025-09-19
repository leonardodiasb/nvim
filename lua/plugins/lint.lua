return {
    { -- Linting
        'mfussenegger/nvim-lint',
        event = { 'BufReadPre', 'BufNewFile' },
        config = function()
            local lint = require('lint')
            
            -- Configure linters for specific filetypes
            lint.linters_by_ft = {
                eruby = { 'erb_lint' },
                ruby = { 'rubocop' },
                javascript = { 'eslint' },
                typescript = { 'eslint' },
                javascriptreact = { 'eslint' },
                typescriptreact = { 'eslint' },
            }
            
            -- Custom erb_lint configuration
            lint.linters.erb_lint = {
                cmd = 'erb_lint',
                stdin = false,
                args = { '--format', 'json' },
                ignore_exitcode = true,
                parser = function(output)
                    local items = {}
                    local ok, decoded = pcall(vim.json.decode, output)
                    if not ok then
                        return items
                    end
                    
                    for _, file in pairs(decoded.files or {}) do
                        for _, offense in ipairs(file.offenses or {}) do
                            table.insert(items, {
                                lnum = offense.location.start_line - 1,
                                col = offense.location.start_column - 1,
                                end_lnum = offense.location.last_line - 1,
                                end_col = offense.location.last_column,
                                severity = offense.severity == 'error' and vim.diagnostic.severity.ERROR or vim.diagnostic.severity.WARN,
                                message = offense.message,
                                source = 'erb_lint',
                            })
                        end
                    end
                    return items
                end,
            }

            -- Create autocommand which carries out the actual linting
            -- on the specified events.
            local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
            vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
                group = lint_augroup,
                callback = function()
                    lint.try_lint()
                end,
            })
        end,
    },
}
