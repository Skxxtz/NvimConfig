local maps = require("custom_plugins.command-palette.maps")


local function fzf(list, query)
    local possible_matches = {}
    local letters = {}
    local unique_letters = {}
    query = query:gsub("^%s*(.-)%s*$", "%1")
    print(query)
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
    end
end



function open_window(win_type)
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

local function format(results)
    local lines = {}
    local modes = {}
    local mods = {}
    local binds = {}
    local explanations = {}
    if #results > 0 then
        for _, row in ipairs(results) do
            table.insert(modes, #row.mode)
            table.insert(mods, #row.mod)
            table.insert(binds, #row.bind)
            table.insert(explanations, #row.explanation)
        end
        local mode_max = math.max(unpack(modes)) + 5
        local mod_max = math.max(unpack(mods)) + 5
        local bind_max = math.max(unpack(binds)) + 10
        local expl_max = math.max(unpack(explanations)) + 3
        for i, row in ipairs(results) do
            local mode = row.mode .. string.rep(" ", mode_max - modes[i])
            local mod = row.mod .. string.rep(" ", mod_max - mods[i])
            local bind = row.bind .. string.rep(" ", bind_max - binds[i])
            local expl = row.explanation .. string.rep(" ", expl_max - explanations[i])
            table.insert(lines, mode .. mod .. bind .. expl)
        end
    end
    return lines
end

vim.api.nvim_create_user_command("SearchCommand", function()
    local result_buf, result_win = open_window("result")
    local prompt_buf, prompt_win = open_window("prompt")
    vim.api.nvim_buf_set_keymap(prompt_buf, "n", "q", ":q<CR>", { silent = true })
    vim.api.nvim_buf_set_keymap(result_buf, "n", "q", ":q<CR>", { silent = true })
    vim.api.nvim_buf_set_keymap(prompt_buf, "n", "<Esc>", ":q<CR>", { silent = true })
    vim.api.nvim_buf_set_keymap(result_buf, "n", "<Esc>", ":q<CR>", { silent = true })
    vim.api.nvim_feedkeys("i", "n", false)

    vim.api.nvim_create_autocmd("TextChangedI", {
        buffer = prompt_buf,
        callback = function()
            local search_term = vim.api.nvim_buf_get_lines(prompt_buf, 0, -1, false)
            for _, line in ipairs(search_term) do
                vim.cmd('echo "' .. line .. '"')
                if line then
                    local lines = {}
                    local results = fzf(maps.keymaps, line)
                    if results then
                        for _, row in ipairs(results) do
                            table.insert(lines,
                                row.mode .. "   " .. row.mod .. "    " .. row.bind .. "    " .. row.explanation)
                        end
                        lines = format(results)
                        vim.api.nvim_buf_set_lines(result_buf, 0, -1, false, lines)
                    else
                        vim.api.nvim_buf_set_lines(result_buf, 0, -1, false, { "" })
                    end
                end
            end
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
