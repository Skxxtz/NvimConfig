local maps = require("custom_plugins.command-palette.maps")
local M = {}

function M.AttatchEvents(prompt_buf, prompt_win, result_buf, result_win, paddings)
    vim.api.nvim_create_augroup("CmdPalletteGroup", { clear = true })
    vim.api.nvim_create_autocmd("TextChangedI", {
        buffer = prompt_buf,
        group = "CmdPalletteGroup",
        callback = function()
            local search_term = vim.api.nvim_buf_get_lines(prompt_buf, 0, -1, false)
            M.Draw(search_term, result_buf, paddings)
        end
    })
    vim.api.nvim_create_autocmd("WinResized", {
        group = "CmdPalletteGroup",
        callback = function ()
            M.ApplyDims(result_win, "Results")
            M.ApplyDims(prompt_win, "Command")
        end
    })

    vim.api.nvim_create_autocmd("WinClosed", {
        group = "CmdPalletteGroup",
        callback = function(args)
            local win_id = tonumber(args.match)
            if win_id == result_win then
                vim.api.nvim_win_close(prompt_win, false)
                vim.api.nvim_del_augroup_by_name("CmdPalletteGroup")
            elseif win_id == prompt_win then
                vim.api.nvim_win_close(result_win, false)
                vim.api.nvim_del_augroup_by_name("CmdPalletteGroup")
            end
        end
    })
end

function M.AttatchBinds(prompt_buf, result_buf)
    vim.api.nvim_buf_set_keymap(prompt_buf, "n", "q", ":q<CR>", { silent = true })
    vim.api.nvim_buf_set_keymap(result_buf, "n", "q", ":q<CR>", { silent = true })
    vim.api.nvim_buf_set_keymap(prompt_buf, "n", "<Esc>", ":q<CR>", { silent = true })
    vim.api.nvim_buf_set_keymap(result_buf, "n", "<Esc>", ":q<CR>", { silent = true })
end

function M.OpenWindow(win_type)
    local buf = vim.api.nvim_create_buf(false, true)
    local width, height, left, top = M.GetDims(win_type)

    local win = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        style = "minimal",
        width = width,
        height = height,
        col = left,
        row = top,
        border = "rounded",
        title = win_type,
        title_pos = "center",
        focusable = win_type == "Command",
    })
    vim.api.nvim_win_set_option(win, "winhighlight", "NormalFloat:Normal")
    return buf, win, width
end

function M.GetDims(win_type)
    local lines = vim.opt.lines:get()
    local cols = vim.opt.columns:get()
    local width = math.ceil(cols * 0.8)
    local left = math.ceil((cols - width) * 0.5)
    local height, top
    if win_type == "Results" then
        height = math.ceil(lines * 0.7 - 4)
        top = 4
    else
        height = 1
        top = math.ceil((lines * 0.75))
    end
    return width, height, left, top
end

function M.ApplyDims(win, win_type)
    local width, height, left, top = M.GetDims(win_type)
    vim.api.nvim_win_set_config(win, {
        relative = "editor",
        width = width,
        height = height,
        col = left,
        row = top,
    })
end

function M.format(results, padding)
    local lines = {}
    local syntax_cols = {}
    local p = padding
    local x_offset = p.left_pad + p.mode_max + p.bind_max
    if #results > 0 then
        for _, row in ipairs(results) do
            local left_padding = string.rep(" ", p.left_pad)
            local mode = row.mode .. string.rep(" ", p.mode_max - #row.mode)
            local bind = row.bind .. string.rep(" ", p.bind_max - vim.fn.strwidth(row.bind))
            local expl = row.explanation .. string.rep(" ", p.expl_max - #row.explanation)
            local new_indices = {}
            for _, index in ipairs(row.indices) do
                table.insert(new_indices, index + x_offset)
            end
            table.insert(syntax_cols, new_indices)
            table.insert(lines, left_padding .. mode .. bind .. expl)
        end
    end
    return lines, syntax_cols
end

function M.Highlight(result_buf, cols)
    if cols then
        vim.api.nvim_set_hl(0, "Green", { fg = UserSettings.CommandPallettePlugin.AccentColor })
        for i, row in ipairs(cols) do
            for _, col in ipairs(row) do
                vim.api.nvim_buf_add_highlight(result_buf, 0, "Green", i - 1, col - 1, col)
            end
        end
    end
end

function M.GetPaddings(width)
    local keymaps = maps.keymaps
    local modes = {}
    local binds = {}
    local explanations = {}
    for _, row in ipairs(keymaps) do
        table.insert(modes, vim.fn.strwidth(row.mode))
        table.insert(binds, vim.fn.strwidth(row.bind))
        table.insert(explanations, vim.fn.strwidth(row.explanation))
    end
    local left_pad = 2
    local mode_max = math.max(unpack(modes))
    local bind_max = math.max(unpack(binds))
    local expl_max = math.max(unpack(explanations))
    local right_pad = 2

    local total_width = left_pad + mode_max + bind_max + expl_max + right_pad
    if total_width + 20 < width then
        mode_max = mode_max + 5
        bind_max = bind_max + 10
    else
        local diff = width - total_width
        mode_max = mode_max + math.floor(diff * 0.25)
        bind_max = bind_max + math.floor(diff *0.5)
    end
    return { left_pad=left_pad, mode_max = mode_max, bind_max = bind_max, expl_max = expl_max, right_pad=right_pad }
end

function M.Draw(search_term, result_buf, paddings)
    local search_for = ""
    for _, line in ipairs(search_term) do
        if line then
            search_for = line
        end
    end

    local results = CmdPallette.fzf(maps.keymaps, search_for)
    local lines, cols = { "" }, {}
    if results then
        lines, cols = M.format(results, paddings)
    end
    vim.bo[result_buf].modifiable = true
    vim.api.nvim_buf_set_lines(result_buf, 0, -1, false, lines)
    vim.bo[result_buf].modifiable = false
    M.Highlight(result_buf, cols)
end

return M
