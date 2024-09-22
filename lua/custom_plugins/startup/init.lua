require("custom_plugins.startup.headers")
require("custom_plugins.startup.startup_image")



vim.api.nvim_create_autocmd("VimEnter", {
    callback = StartupScreen,
})
