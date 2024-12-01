-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- -- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

local opts = { noremap = true, silent = true }
local term_opts = { silent = true }
local keymap = vim.api.nvim_set_keymap

-- Normal --
-- Better window navigation
keymap('n', 'sh', '<C-w>h', opts)
keymap('n', 'sj', '<C-w>j', opts)
keymap('n', 'sk', '<C-w>k', opts)
keymap('n', 'sl', '<C-w>l', opts)

--[[ keymap("n", "<leader>hv", ":Ex<CR>", opts) ]]

-- do not yank with x
keymap('n', 'x', '"_x', opts)

-- increment/decrement
keymap('n', '+', '<C-a>', opts)
keymap('n', '-', '<C-x>', opts)

-- select all
keymap('n', '<C-a>', 'gg<S-v>G', opts)
--new tab
keymap('n', 'ss', ':split<Return>', opts)
keymap('n', 'sv', ':vsplit<Return>', opts)

-- Resize with arrows
keymap('n', '<C-Up>', ':resize +2<CR>', opts)
keymap('n', '<C-Down>', ':resize -2<CR>', opts)
keymap('n', '<C-Left>', ':vertical resize -2<CR>', opts)
keymap('n', '<C-Right>', ':vertical resize +2<CR>', opts)

-- Navigate buffers
keymap('n', '<S-l>', ':bnext<CR>', opts)
keymap('n', '<S-h>', ':bprevious<CR>', opts)

-- Insert --
-- Press jk fast to enter
keymap('i', 'jk', '<ESC>', opts)

-- Visual --
-- Stay in indent mode
keymap('v', '<', '<gv', opts)
keymap('v', '>', '>gv', opts)

-- Move text up and down
keymap('v', 'J', ':m .+1<CR>==', opts)
keymap('v', 'K', ':m .-2<CR>==', opts)
keymap('v', 'p', '"_dP', opts)

-- Visual Block --
-- Move text up and down
keymap('x', 'J', ":move '>+1<CR>gv-gv", opts)
keymap('x', 'K', ":move '<-2<CR>gv-gv", opts)

-- Open netrw
keymap('n', '<leader>e', ':Explore<CR>', opts)

-- My keymaps from vimrc
keymap('n', '<leader>n', ':noh<CR>', opts)

-- Keymaps to center buffer while navigating
keymap('n', '<C-u>', '<C-u>zz', opts)
keymap('n', '<C-d>', '<C-d>zz', opts)
keymap('n', 'gg', 'ggzz', opts)
keymap('n', 'G', 'Gzz', opts)
keymap('n', 'N', 'Nzz', opts)
keymap('n', 'n', 'nzz', opts)
keymap('n', '*', '*zz', opts)
keymap('n', '#', '#zz', opts)
keymap('n', '%', '%zz', opts)
keymap('n', '{', '{zz', opts)
keymap('n', '}', '}zz', opts)

keymap('n', 'L', '$', opts)
keymap('n', 'H', '^', opts)

keymap('n', 'U', '<C-r>', opts)

-- Rotate open windows
keymap('n', '<leader>rw', '<C-w>r', opts)

-- Paste without losing the contents of the register
keymap('n', '<leader>p', '_dP', opts)
--

-- Press 'S' for quick find/replace for the word under the cursor
vim.keymap.set('n', 'S', function()
  local cmd = ':%s/<C-r><C-w>/<C-r><C-w>/gI<Left><Left><Left>'
  local keys = vim.api.nvim_replace_termcodes(cmd, true, false, true)
  vim.api.nvim_feedkeys(keys, 'n', false)
end)

-- load the session for the current directory
vim.keymap.set('n', '<leader>qs', function()
  require('persistence').load()
end)
-- select a session to load
vim.keymap.set('n', '<leader>qS', function()
  require('persistence').select()
end)
-- load the last session
vim.keymap.set('n', '<leader>ql', function()
  require('persistence').load { last = true }
end)
-- stop Persistence => session won't be saved on exit
vim.keymap.set('n', '<leader>qd', function()
  require('persistence').stop()
end)

-- navigate to vault
vim.keymap.set('n', '<leader>oo', ':cd /Users/leonardodias/Documents/obsidian-vault<cr>')
--
-- convert note to template and remove leading white space
vim.keymap.set('n', '<leader>on', ':ObsidianTemplate note<cr> :lua vim.cmd([[1,/^\\S/s/^\\n\\{1,}//]])<cr>')
-- strip date from note title and replace dashes with spaces
-- must have cursor on title
vim.keymap.set('n', '<leader>of', ':s/\\(# \\)[^_]*_/\\1/ | s/-/ /g<cr>')

-- for review workflow
-- move file in current buffer to zettelkasten folder
vim.keymap.set('n', '<leader>ok', ":!mv '%:p' /Users/leonardodias/Documents/obsidian-vault/zettelkasten<cr>:bd<cr>")
-- delete file in current buffer
vim.keymap.set('n', '<leader>odd', ":!rm '%:p'<cr>:bd<cr>")

-- Delete image file under cursor using trash app (macOS)
vim.keymap.set('n', '<leader>id', function()
  local function get_image_path()
    -- Get the current line
    local line = vim.api.nvim_get_current_line()
    -- Pattern to match image path in Markdown
    local image_pattern = '%[.-%]%((.-)%)'
    -- Extract relative image path
    local _, _, image_path = string.find(line, image_pattern)

    return image_path
  end

  -- Get the image path
  local image_path = get_image_path()

  if image_path then
    -- Check if the image path starts with "http" or "https"
    if string.sub(image_path, 1, 4) == 'http' then
      vim.api.nvim_echo({
        { 'URL image cannot be deleted from disk.', 'WarningMsg' },
      }, false, {})
    else
      -- Construct absolute image path
      local current_file_path = vim.fn.expand '%:p:h'
      local absolute_image_path = current_file_path .. '/' .. image_path

      -- Check if trash utility is installed
      if vim.fn.executable 'trash' == 0 then
        vim.api.nvim_echo({
          { '- Trash utility not installed. Make sure to install it first\n', 'ErrorMsg' },
          { '- In macOS run `brew install trash`\n', nil },
        }, false, {})
        return
      end

      -- Prompt for confirmation before deleting the image
      vim.ui.input({
        prompt = 'Delete image file? (y/n) ',
      }, function(input)
        if input == 'y' or input == 'Y' then
          -- Delete the image file using trash app
          local success, _ = pcall(function()
            vim.fn.system { 'trash', vim.fn.fnameescape(absolute_image_path) }
          end)

          if success then
            vim.api.nvim_echo({
              { 'Image file deleted from disk:\n', 'Normal' },
              { absolute_image_path, 'Normal' },
            }, false, {})
            -- I'll refresh the images, but will clear them first
            -- I'm using [[ ]] to escape the special characters in a command
            vim.cmd [[lua require("image").clear()]]
            -- Reloads the file to reflect the changes
            vim.cmd 'edit!'
          else
            vim.api.nvim_echo({
              { 'Failed to delete image file:\n', 'ErrorMsg' },
              { absolute_image_path, 'ErrorMsg' },
            }, false, {})
          end
        else
          vim.api.nvim_echo({
            { 'Image deletion canceled.', 'Normal' },
          }, false, {})
        end
      end)
    end
  else
    vim.api.nvim_echo({
      { 'No image found under the cursor', 'WarningMsg' },
    }, false, {})
  end
end, { desc = '(macOS) Delete image file under cursor' })

-- Set up a keymap to clear all images in the current buffer
vim.keymap.set('n', '<leader>ic', function()
  -- This is the command that clears the images
  -- I'm using [[ ]] to escape the special characters in a command
  vim.cmd [[lua require("image").clear()]]
  print 'Images cleared'
end, { desc = 'Clear images' })
