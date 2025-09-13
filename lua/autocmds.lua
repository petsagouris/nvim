-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
    pattern = "*",
    callback = function()
        vim.highlight.on_yank({ timeout = 170 })
    end,
    group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "netrw",
    callback = function()
        vim.keymap.set("n", "<C-c>", "<cmd>bd<CR>", {buffer = true, silent = true })
        vim.keymap.set("n", "<Tab>", "mf", {buffer = true, remap = true, silent = true })
        vim.keymap.set("n", "<S-Tab>", "mF", {buffer = true, remap = true, silent = true })
        vim.keymap.set("n", "%", function()
            local dir = vim.b.netrw_curdir or vim.fn.expand("%:p:h")
            vim.ui.input({ prompt = "Enter filename: " }, function(input)
                if input and input ~= "" then
                    local filepath = dir .. "/" .. input
                    vim.cmd("!touch " .. vim.fn.shellescape(filepath))
                    vim.api.nvim_feedkeys("<C-l>", "n", false)
                end
            end)
        end, {buffer = true, silent = true })
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function(ev)
        local ft = vim.bo[ev.buf].filetype
        local formatting = "lua vim.lsp.buf.format()"

        if ft == "lua" then
            formatting = "!stylua %"
        elseif ft == "tex" then
            formatting = "!latexindent -s -l -w %"
        end

        local cmd = function()
            vim.cmd("write")
            vim.cmd("silent " .. formatting)
        end

        vim.keymap.set("n", "<leader>fo", cmd, { buffer = ev.buf })
    end,
})
