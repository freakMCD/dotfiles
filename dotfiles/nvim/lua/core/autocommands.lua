local filetype_settings = vim.api.nvim_create_augroup("FileTypeSettings", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
    group = filetype_settings,
    pattern = "tex",
    callback = function()
        vim.opt_local.expandtab = true
        vim.opt_local.tabstop = 1
        vim.opt_local.shiftwidth = 1
        vim.opt_local.softtabstop = 1
    end,
})

