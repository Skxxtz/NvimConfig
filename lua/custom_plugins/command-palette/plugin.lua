local helpers = require("custom_plugins.command-palette.helpers")
CmdPallette = CmdPallette or {}

function CmdPallette:new()
    local instance = {}
    setmetatable(instance, self)
    self.__index = self

    instance:init()
    return instance
end


function CmdPallette:init()
    vim.api.nvim_create_user_command("CmdPalletteShow", function()
        self:Show()
    end, {})
    vim.keymap.set("n", "<leader>oc", function()
        vim.cmd(":CmdPalletteShow")
    end)
end

function CmdPallette.fzf(list, query)
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

function CmdPallette:Show()
    local result_buf, result_win, result_wid = helpers.OpenWindow("Results")
    local prompt_buf, prompt_win, _ = helpers.OpenWindow("Command")
    local paddings = helpers.GetPaddings(result_wid)

    vim.bo[result_buf].buftype = "nofile"
    vim.bo[result_buf].bufhidden = "wipe"
    vim.bo[result_buf].filetype = "CommandPallette"
    vim.bo[prompt_buf].filetype = "CommandPallette"
    vim.bo[result_buf].modifiable = true
    vim.api.nvim_feedkeys("i", "n", false)

    helpers.Draw({""}, result_buf, paddings)
    helpers.AttatchBinds(prompt_buf, result_buf)
    helpers.AttatchEvents(prompt_buf, prompt_win, result_buf, result_win, paddings)
end



local _ = CmdPallette:new()


