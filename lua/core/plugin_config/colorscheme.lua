require("catppuccin").setup({
    flavour = "mocha",
    transparent_background = true,
    styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
        comments = { "italic" }, -- Change the style of comments
    },
})
table.insert(THEMES, "catppuccin")
REVERSE_THEME["catppuccin"] = #THEMES

require("rose-pine").setup({
    variant = "auto",
    dark_variant = "main",
    extend_background_behind_borders = true,
    styles = {
        transparency = true;
    }
})
table.insert(THEMES, "rose-pine")
REVERSE_THEME["rose-pine"] = #THEMES

require("nightfox").setup({
    options = {
        transparent = true,
    }
})
table.insert(THEMES, "nightfox")
REVERSE_THEME["nightfox"] = #THEMES






