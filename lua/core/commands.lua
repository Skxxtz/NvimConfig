TIMER_ID = nil

THEMES = {}
REVERSE_THEME = {}
DEFAULT_THEME = "nightfox"


function ReadTheme()
    local path = vim.fn.stdpath("config") .. "/lua/core/theme.txt"
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
    local path = vim.fn.stdpath("config") .. "/lua/core/theme.txt"
    local file = io.open(path, "w")
    if file then
        file:write(index)
    end
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



function StartupScreen()
    -- Create a new buffer
    if vim.fn.argc() == 0 then
        vim.cmd("enew")

        -- Set buffer options
        vim.cmd("setlocal buftype=nofile")
        vim.cmd("setlocal bufhidden=wipe")
        vim.cmd("setlocal nonumber norelativenumber")
        vim.cmd("setlocal fillchars=eob:\\ ")
        vim.cmd("syntax clear")




        local sign_header = {
            "             88          ",
            "            d88b         ",
            "            8888         ",
            "           d8888         ",
            "         _d88888b        ",
            "       _d88888888b       ",
            "    _cd88888888888b__    ",
            "  cd8888888P  Y888888bo_ ",
            " d88888P        Y8888888b",
            " Y88P               Y888P",
            "",
            "by SKXXTZ",
            "",
            "",
        }

        local maya_header = {
            "             _____               ",
            "            _|[]_|_              ",
            "          _/_/=|_\\_\\_          ",
            "        _/_ /==| _\\ _\\_        ",
            "      _/__ /===|_ _\\ __\\_      ",
            "    _/_ _ /====| ___\\  __\\_    ",
            "  _/ __ _/=====|_ ___\\ ___ \\_  ",
            "_/ ___ _/======| ____ \\_  __ \\_",
            "",
            "by SKXXTZ",
            "",
            "",
        }

        local tree_header = {
            "        # #### ####         ",
            "      ### \\/#|### |/####    ",
            "     ##\\/#/ \\||/##/_/##/_#  ",
            "   ###  \\/###|/ \\/ # ###    ",
            " ##_\\_#\\_\\## | #/###_/_#### ",
            "## #### # \\ #| /  #### ##/##",
            " __#_--###`  |{,###---###-~ ",
            "           \\ }{             ",
            "            }}{             ",
            "            }}{             ",
            "            {{}             ",
            "      , -=-~{ .-^- _        ",
            "            `}              ",
            "             {              ",
            "",
            "by SKXXTZ",
            "",
            "",
        }


        local options = {
            "OPTIONS:",
            "<leader> ff    Find Files",
            "<leader> fg    Find String",
        }
        local header_image
        local line_count
        print(STARTUP_IMAGE)
        if STARTUP_IMAGE == "tree" then
            header_image = tree_header
            line_count = 14
        elseif STARTUP_IMAGE == "S" then
            header_image = sign_header
            line_count = 10
        elseif STARTUP_IMAGE == "Maya" then
            header_image = maya_header
            line_count = 8
        else
            header_image = tree_header
            line_count = 14
        end

        local width = vim.o.columns
        local function center_string(str, w)
            local pad = math.max(0, math.floor((w - #str) / 2))
            return string.rep(" ", pad) .. str
        end

        -- Set the lines in the new buffer
        for _, line in ipairs(header_image) do
            local centered_line = center_string(line, width)
            vim.api.nvim_buf_set_lines(0, -1, -1, false, { centered_line })
        end
        for _, line in ipairs(options) do
            local centered_line = center_string(line, width)
            vim.api.nvim_buf_set_lines(0, -1, -1, false, { centered_line })
        end


        -- Enable cursor line highlighting
        vim.wo.cursorline = false
        vim.cmd("setlocal nomodifiable")

        local function on_enter()
            local line = vim.fn.line(".")
            if line == 100 then
                print("Enter Pressed in line 100")
            end
        end

        vim.keymap.set("n", "<CR>", function ()
            on_enter()
        end, { buffer = 0, noremap = true, silent = true })

        vim.api.nvim_set_hl(0, "Green",  {fg = "#24B364"})
        for i = 1, line_count do
            vim.api.nvim_buf_add_highlight(0, -1, "Green", i, 0, -1)
        end


        vim.cmd("augroup RestoreSyntax")
        vim.cmd("autocmd!")
        vim.cmd("augroup END")
    end
end


