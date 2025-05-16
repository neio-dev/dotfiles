return {
    'nvim-telescope/telescope.nvim', tag = '0.1.8',
      dependencies = { 'nvim-lua/plenary.nvim' },
      config = function()
          local telescope = require('telescope')
          telescope.setup({
                defaults = {
                    file_ignore_patterns = {
                        "%:Zone%.Identifier$",
                        "node_modules",
                    }
                },
                pickers = {
                    colorscheme = { enable_preview = true }
                }
          })
          telescope.load_extension('harpoon')
      end,
    }
