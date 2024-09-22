require("custom_plugins.startup.headers")

local function CenterString(str, w)
    local pad = math.max(0, math.floor((w - #str) / 2))
    return string.rep(" ", pad) .. str
end

local function ShowLines(line_content)
    local width = vim.fn.winwidth(0)
    local lines = {}
    for _, line in ipairs(line_content) do
        local centered_line = CenterString(line, width)
        table.insert(lines, centered_line)
    end
    vim.api.nvim_buf_set_lines(0, -1, -1, false, lines)
end

local function ColorLines(line_count)
    vim.api.nvim_set_hl(0, "Green", { fg = "#24B364" })
    for i = 0, line_count do
        vim.api.nvim_buf_add_highlight(0, -1, "Green", i, 0, -1)
    end
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


        local header_image = get_header()
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
            "",
            "",
        }
        local options = {
            "OPTIONS",
            "",
            "<leader> oc    Open Configs  ",
            "<leader> or    Open README.MD",
            "<leader> ff    Find Files    ",
            "<leader> fg    Find String   ",
        }
        local line_count = #header_image + #signiture
        ShowLines(header_image)
        ShowLines(signiture)
        ShowLines(padding)
        ShowLines(options)
        ColorLines(line_count)

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

        vim.keymap.set("n", "<leader>oc", function ()
            vim.cmd("cd " .. vim.fn.stdpath("config"))
            vim.cmd(":Ex")
        end, { buffer = 0, noremap = true, silent = true })

        vim.keymap.set("n", "<leader>or", function ()
            vim.cmd(":e " .. vim.fn.stdpath("config") .. "/README.md")
        end, { buffer = 0, noremap = true, silent = true })

        vim.bo[buffer].modifiable = false
        vim.cmd("augroup RestoreSyntax")
        vim.cmd("autocmd!")
        vim.cmd("augroup END")
    end
end

