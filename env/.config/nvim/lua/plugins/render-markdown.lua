return {
    'MeanderingProgrammer/render-markdown.nvim',
    opts = {},
    config = function()
        require('render-markdown').setup({
            checkbox = {
                enabled = true,
                unchecked = {
                    -- Replaces '[ ]' of 'task_list_marker_unchecked'.
                    icon = '󰄱 ',
                    -- Highlight for the unchecked icon.
                    highlight = 'RenderMarkdownUnchecked',
                    -- Highlight for item associated with unchecked checkbox.
                    scope_highlight = nil,
                },
                custom = {
                    todo_error = { raw = '[!]', rendered = '󱋭 ', highlight = 'RenderMarkdownUnchecked', scope_highlight = nil },
                    todo_fix = { raw = '[.]', rendered = '󰄗 ', highlight = 'RenderMarkdownUnchecked', scope_highlight = nil },
                },
            },
        })
    end,
}
