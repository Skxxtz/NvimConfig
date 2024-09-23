require("custom_plugins.startup.headers")

local function CenterString(str, w)
    local display_width = vim.fn.strwidth(str)
    local pad = math.max(0, math.floor((w - display_width) / 2))
    return string.rep(" ", pad) .. str
end

local function CenterStringVert(list, height)
    local diff = math.floor((height - #list) / 2) - 2
    local vert_padding = {}
    for _ = 1, diff do
       table.insert(vert_padding, "")
    end
    for _, line in ipairs(list) do
        table.insert(vert_padding, line)
    end
    return vert_padding
end

local function ShowLines(line_content, width)
    local lines = {}
    for _, line in ipairs(line_content) do
        local centered_line = CenterString(line, width)
        table.insert(lines, centered_line)
    end
    vim.api.nvim_buf_set_lines(0, -1, -1, false, lines)
end

local function ColorLinesVert(line_count)
    vim.api.nvim_set_hl(0, "Green", { fg = "#24B364" })
    for i = 0, line_count do
        vim.api.nvim_buf_add_highlight(0, -1, "Green", i, 0, -1)
    end
end

local function ColorLinesHor(line_count, col_end)
    vim.api.nvim_set_hl(0, "Green", { fg = "#24B364"})
    for i = 0, line_count do
        vim.api.nvim_buf_add_highlight(0, -1, "Green", i, 0, col_end)
    end
end

local function AddKeybinds()
    vim.keymap.set("n", "<leader>oc", function ()
        vim.cmd("cd " .. vim.fn.stdpath("config"))
        vim.cmd(":Ex")
    end, { buffer = 0, noremap = true, silent = true })

    vim.keymap.set("n", "<leader>or", function ()
        vim.cmd(":e " .. vim.fn.stdpath("config") .. "/README.md")
    end, { buffer = 0, noremap = true, silent = true })

end

local function GetMaxWidth(list)
    local width = 0
    for _,str in ipairs(list) do
        width = math.max(width, #str)
    end
    return width
end

local function Draw(width, height, header_image, signiture, padding, options)
    if height < #header_image + #signiture + #padding + #options then
        local new_image = {}
        local new_options = {}
        local new_content = {}
        local header_image_width = GetMaxWidth(header_image)
        local signiture_width = GetMaxWidth(signiture)
        local options_width = GetMaxWidth(options)
        local image_width = math.max(header_image_width, signiture_width)
        local side_padding = math.floor((width - (image_width + options_width)) / 3)
        local middle =  width / 2

        for _,line in ipairs(header_image) do
            local centered_line = CenterString(line, middle)
            centered_line = centered_line .. string.rep(" ", (middle - #centered_line))
            table.insert(new_image, centered_line)
        end
        for _,line in ipairs(signiture) do
            local centered_line = CenterString(line, middle)
            centered_line = centered_line .. string.rep(" ", (middle - #centered_line))
            table.insert(new_image, centered_line)
        end
        for _,line in ipairs(options) do
            local centered_line = CenterString(line,  middle)
            table.insert(new_options, centered_line)
        end
        for i = 1, math.max(#new_image, #new_options) do
            local str1 = new_image[i] or ""
            local str2 = new_options[i] or ""
            table.insert(new_content, str1 .. str2)
        end
        new_content = CenterStringVert(new_content, height)
        vim.api.nvim_buf_set_lines(0, -2, -1, false, new_content)

        ColorLinesHor(#new_content, math.floor(middle))

    else
        local line_count = #header_image + #signiture

        ShowLines(header_image, width)
        ShowLines(signiture, width)
        ShowLines(padding, width)
        ShowLines(options, width)
        ColorLinesVert(line_count)
    end
end

local function ClearAll(buf)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, {})
end


function StartupScreen(buffer, original_options)
    if vim.fn.argc() == 0 then
        local header_image = GetHeader()
        local signiture = GetSigniture()
        local padding = {"", "", "",}
        local options = {
            "",
            "",
            "╭─OPTIONS───────────────────────╮",
            "│ <leader> oc    Open Configs   │",
            "│ <leader> or    Open README.MD │",
            "│ <leader> ff    Find Files     │",
            "│ <leader> fg    Find String    │",
            "╰───────────────────────────────╯",
        }
        -- Draw the components to the screen
        local width
        local height
        local function main_loop()
            if buffer == vim.api.nvim_get_current_buf() then
                if width ~= vim.fn.winwidth(0) or height ~=vim.fn.winheight(0) then
                   width = vim.fn.winwidth(0)
                   height = vim.fn.winheight(0)
                   vim.bo[buffer].modifiable = true
                   ClearAll(buffer)
                   Draw(width, height, header_image, signiture, padding, options)
                   vim.bo[buffer].modifiable = false
                end

                vim.defer_fn(function ()
                    main_loop()
                end, 100)
            else
                vim.api.nvim_clear_autocmds({group = "StartupOptions"})
            end
        end
        AddKeybinds()
        main_loop()

        vim.api.nvim_create_augroup("SettingsRevertion", { clear = true })
        vim.api.nvim_create_autocmd("BufWinLeave", {
            group = "SettingsRevertion",
            buffer = buffer,
            callback = function()
                vim.opt_local.number = original_options.number
                vim.opt_local.relativenumber = original_options.relativenumber
                vim.opt_local.mousescroll = original_options.mousescroll
                vim.wo.signcolumn = original_options.signcolumn
                vim.opt.foldmethod = original_options.foldmethod
                vim.wo.cursorline = original_options.cursorline
            end,
        })
        vim.api.nvim_create_autocmd("BufEnter", {
            group = "SettingsRevertion",
            buffer = buffer,
            callback = function()
                main_loop()
            end,
        })

        vim.bo[buffer].modifiable = false
    end
end



local original_options = {
    number = vim.wo.number,
    relativenumber = vim.wo.relativenumber,
    mousescroll = vim.opt_local.mousescroll,
    signcolumn = vim.wo.signcolumn,
    foldmethod = vim.opt.foldmethod,
    cursorline = vim.wo.cursorline,
}


vim.api.nvim_create_augroup("StartupOptions", { clear = true })
vim.api.nvim_create_autocmd("VimEnter", {
    group = "StartupOptions",
    callback = function ()
        local buffer = vim.api.nvim_get_current_buf()
            vim.bo[buffer].buftype = "nofile"
            vim.bo[buffer].bufhidden = "wipe"
            vim.cmd("setlocal mousescroll=ver:0,hor:0")
            vim.cmd("setlocal norelativenumber")
            vim.cmd("setlocal nonumber")
            vim.wo.signcolumn = "no"
            vim.opt.foldmethod = "manual"
            vim.wo.cursorline = false
        StartupScreen(buffer, original_options)
    end,
})
