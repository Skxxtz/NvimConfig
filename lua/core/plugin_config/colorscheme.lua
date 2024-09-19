require("catppuccin").setup({
    flavour = "mocha",
    transparent_background = true,
    styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
        comments = { "italic" }, -- Change the style of comments
    },
})

require("rose-pine").setup({
    variant = "auto",
    dark_variant = "main",
    extend_background_behind_borders = true,
    styles = {
        transparency = true;
    }
})

require("nightfox").setup({
    options = {
        transparent = true,
    }
})

vim.o.termguicolors = true
vim.o.background = "dark"


local timer_id = nil

local themes = {
    "catppuccin",
    "rose-pine",
    "nightfox",
}

if vim.g.current_theme == nil then
    vim.g.current_theme = 3
end

function ChangeTheme()
    vim.g.current_theme = (vim.g.current_theme % #themes) + 1
    LoadTheme()
end



function ClearTerm()
    vim.cmd[[:echo ""]]
    timer_id = nil
end

function LoadTheme()
    local theme = themes[vim.g.current_theme]
    vim.cmd("colorscheme " .. theme)
    print("Theme set to " .. theme)
    if timer_id then
        timer_id:stop()
        timer_id = nil
    end
    timer_id = vim.defer_fn(function ()
        ClearTerm();
    end, 500)
end





LoadTheme();
