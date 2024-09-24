local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end

vim.opt.rtp:prepend(lazypath)

-- ENVS
CPP_COMPILER = "g++" -- "clang++"
CPP_VERSION = "-std=c++20"
PLATFORM = os.getenv("OS")
STARTUP_IMAGE = "Tree"
STARTUP_SIGNITURE = "Squirly"

require("core.commands")
require("core.keymaps")
require("core.plugins")
require("core.plugin_config")
require("core.options")
require("custom_plugins.startup")
require("custom_plugins.command-palette")
