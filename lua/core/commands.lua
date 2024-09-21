THEMES = {"catppuccin", "rose-pine", "nightfox"}
DEFAULT_THEME = "nightfox"
TIMER_ID = nil

local reverse_theme = {
    ["catppuccin"] = 1,
    ["rose-pine"] = 2,
    ["nightfox"] = 3,
}



function ClearTerm()
    vim.cmd[[:echo ""]]
    TIMER_ID = nil
end

function AddOrReplaceTimer(time, func)
    if TIMER_ID then
        TIMER_ID:stop()
        TIMER_ID = nil
    end
    TIMER_ID = vim.defer_fn(function ()
        func()

    end, time)
end


vim.api.nvim_create_user_command("Theme", function (opts)
    local args = vim.split(opts.args, " ");
    local theme = args[1]
    if theme == "" then
        print(THEMES[vim.g.current_theme])
        AddOrReplaceTimer(750, ClearTerm)
    else
        local index = reverse_theme[theme]
        vim.g.current_theme = index
        vim.cmd("colorscheme " .. theme)
    end

end, {
nargs = "*",
complete = function (_,_,_)
    return THEMES
end})


