TIMER_ID = nil

THEMES = {}
REVERSE_THEME = {}
DEFAULT_THEME = "nightfox"


function ReadTheme()
    local path = vim.fn.stdpath("config") .. "/data/theme.txt"
    local file = io.open(path, "r")
    if file then
        local theme = file:read("*l")
        file:close()
        return tonumber(theme)
    else
        print("No such file")
    end
end

function WriteTheme(index)
    local path = vim.fn.stdpath("config") .. "/data/theme.txt"
    local file = io.open(path, "w")
    if file then
        file:write(index)
    end
end

function PrintOutput(output, time)
    AddOrReplaceTimer(10, ClearTerm)
    local lines = vim.split(output, "\n")
    for _,line in ipairs(lines) do
      print(line)
    end
    AddOrReplaceTimer(time, ClearTerm)
end


function ClearTerm()

    vim.cmd [[:echo ""]]
    TIMER_ID = nil
end

function AddOrReplaceTimer(time, func)
    if TIMER_ID then
        TIMER_ID:stop()
        TIMER_ID = nil
    end
    TIMER_ID = vim.defer_fn(function()
        func()
    end, time)
end

function LoadTheme(params)
    local index = params.index or ""
    local name = params.name or ""

    if name then
        index = REVERSE_THEME[name]
    end
    if index then
        WriteTheme(index)
        vim.g.current_theme = index
        vim.cmd("colorscheme " .. name)
    end
end

vim.api.nvim_create_user_command("Theme", function(opts)
    local args = vim.split(opts.args, " ");
    local theme = args[1]
    if theme == "" then
        print(THEMES[vim.g.current_theme])
        AddOrReplaceTimer(750, ClearTerm)
    else
        LoadTheme({ name = theme })
    end
end, {
    nargs = "*",
    complete = function(_, _, _)
        return THEMES
    end
})




