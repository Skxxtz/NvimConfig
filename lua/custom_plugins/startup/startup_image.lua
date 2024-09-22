require("custom_plugins.startup.headers")

local function CenterString(str, w)
    local pad = math.max(0, math.floor((w - #str) / 2))
    return string.rep(" ", pad) .. str
end

local function ShowLines(line_content, width)
    local lines = {}
    for _, line in ipairs(line_content) do
        local centered_line = CenterString(line, width)
        table.insert(lines, centered_line)
    end
    vim.api.nvim_buf_set_lines(0, -2, -1, false, lines)
end

local function ColorLinesVert(line_count)
    vim.api.nvim_set_hl(0, "Green", { fg = "#24B364" })
    for i = 0, line_count do
        vim.api.nvim_buf_add_highlight(0, -1, "Green", i, 0, -1)
    end
end

local function ColorLinesHor(line_count, col_end)
    vim.api.nvim_set_hl(0, "Green", { fg = "#24B364" })
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


function StartupScreen()
    -- Create a new buffer
    if vim.fn.argc() == 0 then
        vim.cmd("enew")
        local buffer = vim.api.nvim_get_current_buf()
        vim.bo[buffer].buftype = "nofile"
        vim.bo[buffer].bufhidden = "wipe"
        vim.cmd("setlocal mousescroll=ver:0,hor:0")
        vim.cmd("setlocal norelativenumber")
        vim.cmd("setlocal nonumber")

        vim.cmd(string.format([[
        augroup MouseScrollSetting
        autocmd!
        autocmd BufWinLeave <buffer=%d> setlocal nonumber
        autocmd BufWinLeave <buffer=%d> setlocal relativenumber
        autocmd BufWinLeave <buffer=%d> setlocal mousescroll=ver:1,hor:1
        augroup END
        ]], buffer, buffer, buffer))


        local header_image = GetHeader()
        local signiture = {
            " _____ _____ _____ _____ ",
            "|| N ||| V ||| I ||| M ||",
            "||___|||___|||___|||___||",
            "|/___\\|/___\\|/___\\|/___\\|"
        }
        local padding = {
            "",
            "",
            "",
        }
        local options = {
            "",
            "",
            "OPTIONS",
            "",
            "<leader> oc    Open Configs  ",
            "<leader> or    Open README.MD",
            "<leader> ff    Find Files    ",
            "<leader> fg    Find String   ",
        }

        local width = vim.fn.winwidth(0)
        local height = vim.fn.winheight(0)

        if height < #header_image + #signiture + #padding + #options then
            local new_image = {}
            local new_options = {}
            local new_content = {}
            local header_image_width = GetMaxWidth(header_image)
            local signiture_width = GetMaxWidth(signiture)
            local options_width = GetMaxWidth(options)
            local image_width = math.max(header_image_width, signiture_width)
            local side_padding = math.floor((width - (image_width + options_width)) / 3)
            local middle = 1.5 * side_padding + header_image_width

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
                local centered_line = CenterString(line, (width - middle))
                table.insert(new_options, centered_line)
            end
            for i = 1, math.max(#new_image, #new_options) do
                local str1 = new_image[i] or ""
                local str2 = new_options[i] or ""
                table.insert(new_content, str1 .. str2)
            end
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

        -- Enable cursor line highlighting
        vim.wo.cursorline = false
        vim.cmd("setlocal nomodifiable")

        AddKeybinds()

        vim.bo[buffer].modifiable = false
        vim.cmd("augroup RestoreSyntax")
        vim.cmd("autocmd!")
        vim.cmd("augroup END")
    end
end

