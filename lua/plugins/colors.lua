return {
  { -- You can easily change to a different colorscheme.
    -- Change the name of the colorscheme plugin below, and then
    -- change the command in the config to whatever the name of that colorscheme is.
    --
    -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
    'folke/tokyonight.nvim',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    init = function()
      -- Load the colorscheme here.
      -- Like many other themes, this one has different styles, and you could load
      -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
      vim.cmd.colorscheme 'kanagawa-paper'

      -- You can configure highlights by doing something like:
      -- vim.cmd.hi 'Comment gui=none'
      vim.api.nvim_set_hl(0, 'Visual', {
        reverse = true,
        bg = '#4a433d',
      })
    end,
  },
  'shaunsingh/nord.nvim',
  -- {
  --   'morhetz/gruvbox',
  -- },
  'gruvbox-community/gruvbox',
  'neanias/everforest-nvim',
  'sho-87/kanagawa-paper.nvim',
  'dracula/vim',
  'EdenEast/nightfox.nvim',
  -- 'sainnhe/gruvbox-material',
  'rebelot/kanagawa.nvim',

  -- theme onedarkpro
  'olimorris/onedarkpro.nvim',
  -- 'navarasu/onedark.nvim',
  -- Colorize hex text
  {
    'norcalli/nvim-colorizer.lua',
    config = function()
      -- Attaches to every FileType mode
      require('colorizer').setup()

      -- Attach to certain Filetypes, add special configuration for `html`
      -- Use `background` for everything else.
      require('colorizer').setup {
        'css',
        'javascript',
        html = {
          mode = 'foreground',
        },
      }

      -- Use the `default_options` as the second parameter, which uses
      -- `foreground` for every mode. This is the inverse of the previous
      -- setup configuration.
      require('colorizer').setup({
        'css',
        'javascript',
        html = { mode = 'background' },
      }, { mode = 'foreground' })

      -- Use the `default_options` as the second parameter, which uses
      -- `foreground` for every mode. This is the inverse of the previous
      -- setup configuration.
      require('colorizer').setup {
        '*', -- Highlight all files, but customize some others.
        css = { rgb_fn = true }, -- Enable parsing rgb(...) functions in css.
        html = { names = false }, -- Disable parsing "names" like Blue or Gray
      }

      -- Exclude some filetypes from highlighting by using `!`
      require('colorizer').setup {
        '*', -- Highlight all files, but customize some others.
        '!vim', -- Exclude vim from highlighting.
        -- Exclusion Only makes sense if '*' is specified!
      }
    end,
  },
}
