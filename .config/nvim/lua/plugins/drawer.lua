return {
    'mikew/nvim-drawer',
    config = function(_, opts)
        local drawer = require('nvim-drawer')
        drawer.setup(opts)

        -- Create term drawer
        drawer.create_drawer({
            position = 'float',
            win_config = {
                anchor = 'SC',
                width = '100%',
                height = '45%',
            },
            on_vim_enter = function(event)
               vim.keymap.set('n','<leader>tt', function()
                    event.instance.focus_or_toggle()
                end) 
                vim.keymap.set('n', '<leader>tf', function()
                    event.instance.toggle_zoom()
               end)
                vim.keymap.set('n', '<leader>tc', function()
                    event.instance.open({ mode = 'new' })
                end)
                vim.keymap.set('n', '<leader>to', function()
                    event.instance.go(1)
                end)
                vim.keymap.set('n', '<leader>tn', function()
                    event.instance.go(-1)
                end)
           end,

            on_did_create_buffer = function()
                vim.fn.termopen(os.getenv('SHELL'))
            end,

            on_did_open_buffer = function()
                vim.opt_local.number = false
                vim.opt_local.signcolumn = 'no'
                vim.opt_local.statuscolumn = ''
            end,

            on_did_open = function()
                vim.cmd('$')
            end
        })

        -- Create notes drawer
        drawer.create_drawer({
            position = 'float',
            win_config = {
                anchor = 'SC',
                width = '100%',
                height = '45%',
            },

            does_own_buffer = function(context)
                return context.bufname:match('NOTES.md') ~= nil
            end,

            on_vim_enter = function(event)
               vim.keymap.set('n','<leader>nn', function()
                    event.instance.focus_or_toggle()
                end) 
                vim.keymap.set('n', '<leader>nf', function()
                    event.instance.toggle_zoom()
                end)
           end,

            on_did_create_buffer = function()
                vim.cmd('edit NOTES.md')
            end,
        })


    end
}
