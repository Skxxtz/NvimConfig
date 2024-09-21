-- CATPPUCCIN THEME: https://github.com/catppuccin/nvim
-- VARIANTS: latte, frappe, macchiato, mocha
require("catppuccin").setup({
    flavour = "mocha",
    transparent_background = true,
    styles = {
        comments = { "italic" },
    },
})
table.insert(THEMES, "catppuccin")
REVERSE_THEME["catppuccin"] = #THEMES


-- ROSE PINE THEME: https://github.com/rose-pine/neovim
-- VARIANTS: dawn, moon, auto, 
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





--  NIGHTFOX THEME: https://github.com/EdenEast/nightfox.nvim
--  VARIANTS: night, day, dawn, dusk, carbon
require("nightfox").setup({
    options = {
        transparent = true,
    }
})
table.insert(THEMES, "nightfox")
REVERSE_THEME["nightfox"] = #THEMES

table.insert(THEMES, "carbonfox")
REVERSE_THEME["carbonfox"] = #THEMES




-- WHITEOUT THEME:
table.insert(THEMES, "whiteout")
REVERSE_THEME["whiteout"] = #THEMES


-- ZELLNER THEME:
table.insert(THEMES, "zellner")
REVERSE_THEME["zellner"] = #THEMES
