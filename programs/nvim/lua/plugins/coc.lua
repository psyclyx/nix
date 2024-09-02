local function show_docs()
    local cw = vim.fn.expand('<cword>')
    if vim.fn.index({'vim', 'help'}, vim.bo.filetype) >= 0 then
        vim.api.nvim_command('h ' .. cw)
    elseif vim.api.nvim_eval('coc#rpc#ready()') then
        vim.fn.CocActionAsync('doHover')
    else
        vim.api.nvim_command('!' .. vim.o.keywordprg .. ' ' .. cw)
    end
end

return {
    {
        "neoclide/coc.nvim",
        branch = "release",
        init = function()
            vim.g.coc_global_extensions = { "coc-clojure", "coc-json", "coc-zig" }
        end,
        config = function()
            vim.api.nvim_create_augroup("CocGroup", {})
            vim.api.nvim_create_autocmd("CursorHold", {
                group = "CocGroup",
                command = "silent call CocActionAsync('highlight')",
                desc = "Highlight symbol under cursor on CursorHold"
            })
        end,
        keys = {
            { "K", show_docs, silent = true },
            { "<c-space>", "coc#refresh()", mode = "i", silent = true, expr = true },

            { "[g", "<Plug>(coc-diagnostic-prev)", silent = true },
            { "]g", "<Plug>(coc-diagnostic-next)", silent = true },

            { "gd", "<Plug>(coc-definition)", silent = true },
            { "gy", "<Plug>(coc-type-definition)", silent = true },
            { "gi", "<Plug>(coc-implementation)", silent = true },
            { "gr", "<Plug>(coc-references)", silent = true },
        }
    }
}
