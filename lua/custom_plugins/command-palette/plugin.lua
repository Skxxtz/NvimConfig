local maps = require("custom_plugins.command-palette.maps")


local function fzf(list, query)
    local possible_matches = {}
    local letters = {}
    local unique_letters = {}
    query = query:gsub("^%s*(.-)%s*$", "%1")
    for i = 1, #query do
        local letter = query:sub(i, i)
        letters[letter] = 0
    end
    for key, _ in pairs(letters) do
        table.insert(unique_letters, key)
    end
    if table.concat(unique_letters) ~= "" then
        local pattern = string.format("[^%s]", table.concat(unique_letters, ""))
        for _, row in ipairs(list) do
            local explanation = string.lower(row.explanation)
            local hot_explanation = explanation:gsub(pattern, "")
            local cold_explanation = explanation:gsub(pattern, "0")
            local pattern_match = string.find(hot_explanation, query, 1, true)
            if pattern_match then
                local indices = {}
                local counter = 0
                for i = 1, #cold_explanation do
                    if cold_explanation:sub(i, i) ~= "0" then
                        counter = counter + 1
                        if counter >= pattern_match and counter < (pattern_match + #query) then
                            table.insert(indices, i)
                        end
                    end
                end
                row["indices"] = indices
                table.insert(possible_matches, row)
            end
        end
        return possible_matches
    else
        for _, row in ipairs(list) do
            row["indices"] = {}
        end
        return list
    end
end



local function open_window(win_type)
    local buf = vim.api.nvim_create_buf(false, true)
    local lines = vim.opt.lines:get()
    local cols = vim.opt.columns:get()
    local width = math.ceil(cols * 0.8)
    local left = math.ceil((cols - width) * 0.5)
    local height, top
    if win_type == "result" then
        height = math.ceil(lines * 0.7 - 4)
        top = 4
    else
        height = 1
        top = math.ceil((lines * 0.75))
    end

    local win = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        style = "minimal",
        width = width,
        height = height,
        col = left,
        row = top,
        border = "rounded",
        title = "Results",
        title_pos = "center",
    })
    vim.api.nvim_win_set_option(win, "winhighlight", "NormalFloat:Normal")
    return buf, win
end


local function format(results, padding)
    local lines = {}
    local syntax_cols = {}
    local p = padding
    local x_offset = p.mode_max + p.mod_max + p.bind_max
    if #results > 0 then
        for _, row in ipairs(results) do
            local mode = row.mode .. string.rep(" ", p.mode_max - #row.mode)
            local mod = row.mod .. string.rep(" ", p.mod_max - #row.mod)
            local bind = row.bind .. string.rep(" ", p.bind_max - vim.fn.strwidth(row.bind))
            local expl = row.explanation .. string.rep(" ", p.expl_max - #row.explanation)
            local new_indices = {}
            for _, index in ipairs(row.indices) do
                table.insert(new_indices, index + x_offset)
            end
            table.insert(syntax_cols, new_indices)
            table.insert(lines, mode .. mod .. bind .. expl)
        end
    end
    return lines, syntax_cols
end
local function highlight(result_buf, cols)
    if cols then
        vim.api.nvim_set_hl(0, "Green", { fg = "#24B364" })
        for i, row in ipairs(cols) do
            for _, col in ipairs(row) do
                vim.api.nvim_buf_add_highlight(result_buf, 0, "Green", i - 1, col - 1, col)
            end
        end
    end
end

local function get_paddings()
    local keymaps = maps.keymaps
    local modes = {}
    local mods = {}
    local binds = {}
    local explanations = {}
    for _, row in ipairs(keymaps) do
        table.insert(modes, vim.fn.strwidth(row.mode))
        table.insert(mods, vim.fn.strwidth(row.mod))
        table.insert(binds, vim.fn.strwidth(row.bind))
        table.insert(explanations, vim.fn.strwidth(row.explanation))
    end
    local mode_max = math.max(unpack(modes)) + 5
    local mod_max = math.max(unpack(mods)) + 5
    local bind_max = math.max(unpack(binds)) + 10
    local expl_max = math.max(unpack(explanations)) + 3
    return { mode_max = mode_max, mod_max = mod_max, bind_max = bind_max, expl_max = expl_max }
end

local function draw(search_term, result_buf, paddings)
    local search_for = ""
    for _, line in ipairs(search_term) do
        if line then
            search_for = line
        end
    end

    local results = fzf(maps.keymaps, search_for)
    local lines, cols = { "" }, {}
    if results then
        lines, cols = format(results, paddings)
    end
    vim.bo[result_buf].modifiable = true
    vim.api.nvim_buf_set_lines(result_buf, 0, -1, false, lines)
    vim.bo[result_buf].modifiable = false
    highlight(result_buf, cols)
end

vim.api.nvim_create_user_command("SearchCommand", function()
    local paddings = get_paddings()
    local result_buf, result_win = open_window("result")
    local prompt_buf, prompt_win = open_window("prompt")

    vim.bo[result_buf].buftype = "nofile"
    vim.bo[result_buf].bufhidden = "wipe"
    vim.bo[result_buf].modifiable = false
    vim.api.nvim_buf_set_keymap(prompt_buf, "n", "q", ":q<CR>", { silent = true })
    vim.api.nvim_buf_set_keymap(result_buf, "n", "q", ":q<CR>", { silent = true })
    vim.api.nvim_buf_set_keymap(prompt_buf, "n", "<Esc>", ":q<CR>", { silent = true })
    vim.api.nvim_buf_set_keymap(result_buf, "n", "<Esc>", ":q<CR>", { silent = true })
    vim.api.nvim_feedkeys("i", "n", false)

    draw({""}, result_buf, paddings)
    vim.api.nvim_create_autocmd("TextChangedI", {
        buffer = prompt_buf,
        callback = function()
            local search_term = vim.api.nvim_buf_get_lines(prompt_buf, 0, -1, false)
            draw(search_term, result_buf, paddings)
        end
    })

    vim.api.nvim_create_autocmd("WinClosed", {
        callback = function(args)
            local win_id = tonumber(args.match)
            if win_id == result_win then
                vim.api.nvim_win_close(prompt_win, false)
            elseif win_id == prompt_win then
                vim.api.nvim_win_close(result_win, false)
            end
        end
    })
end, {})


vim.keymap.set("n", "<leader>oc", function()
    vim.cmd(":SearchCommand")
end)
