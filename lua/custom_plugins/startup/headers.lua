M = {}
function M.get_header()
    local sign_header = {
        "                         ",
        "                         ",
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
    }

    local nvim_text = {
            "                             d8,                  ",
            "                            `8P                   ",
            "",
            "  88bd88b     ?88   d8P      88b      88bd8b,d88b ",
            "  88P' ?8b    d88  d8P'      88P      88P'`?8P'?8b",
            " d88   88P    ?8b ,88'      d88      d88  d88  88P",
            "d88'   88b    `?888P'      d88'     d88' d88'  88b",
            "",
            "",
    }

    local maya_header = {
        "                                 ",
        "                                 ",
        "             _____               ",
        "            _|[]_|_              ",
        "          _/_/=|_\\_\\_          ",
        "        _/_ /==| _\\ _\\_        ",
        "      _/__ /===|_ _\\ __\\_      ",
        "    _/_ _ /====| ___\\  __\\_    ",
        "  _/ __ _/=====|_ ___\\ ___ \\_  ",
        "_/ ___ _/======| ____ \\_  __ \\_",
        "",
    }

    local tree_header = {
        "                             ",
        "                             ",
        "         # #### ####         ",
        "       ### \\/#|### |/####    ",
        "      ##\\/#/ \\||/##/_/##/_#  ",
        "    ###  \\/###|/ \\/ # ###    ",
        "  ##_\\_#\\_\\## | #/###_/_#### ",
        " ## #### # \\ #| /  #### ##/##",
        "  __#_--###`  |{,###---###-~ ",
        "            \\ }{             ",
        "             }}{             ",
        "             }}{             ",
        "             {{}             ",
        "       , -=-~{ .-^- _        ",
        "",
    }

    local header_image
    if UserSettings.StartUpPlugin.Header == "Tree" then
        header_image = tree_header
    elseif UserSettings.StartUpPlugin.Header == "Sign" then
        header_image = sign_header
    elseif UserSettings.StartUpPlugin.Header == "Nvim_Text" then
        header_image = nvim_text
    elseif UserSettings.StartUpPlugin.Header == "Maya" then
        header_image = maya_header
    else
        header_image = tree_header
    end
    return header_image
end




function M.get_signiture()
    local squirly = {
            "┳┓ ┓┏ ┳ ┳┳┓",
            "┃┃ ┃┃ ┃ ┃┃┃",
            "┛┗ ┗┛ ┻ ┛ ┗",
    }

    local header_signiture
    if UserSettings.StartUpPlugin.Signiture == "Squirly" then
        header_signiture = squirly
    else
        header_signiture = squirly
    end
    return header_signiture
end

return M
