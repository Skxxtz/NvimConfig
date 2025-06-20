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

function PrintOutput(output)
    local lines = vim.split(output, "\n")
    for _, line in ipairs(lines) do
        print(line)
    end
end

function ClearTerm()
    vim.cmd [[:echo ""]]
    TIMER_ID = nil
end

function AddOrReplaceTimer(time, func)
    if TIMER_ID then
        TIMER_ID:stop()
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

function RunCompiledProgram()
    local file = vim.fn.expand("%:p:r")
    local extension = vim.fn.expand("%:t:e")
    if extension == "rs" then
        vim.cmd("! cargo run")
    elseif extension == "cpp" then
        local command
        if UserSettings.Os.Platform == "Windows_NT" then
            command = string.format("! %s.exe", file)
        else
            command = string.format("! ./%s", file)
        end
        vim.cmd(command)
    elseif extension == "py" then
        vim.cmd(string.format("! python %s.py", file))
    elseif extension == "sh" and UserSettings.Os.Platform ~= "Windows_NT" then
        vim.cmd(string.format("! %s.%s", file, extension))
    elseif extension == "ts" and UserSettings.Os.Platform ~= "Windows_NT" then
        vim.cmd("npx tsc")
    end
end

-- Define the function to strip trailing whitespace
local function strip_trailing_whitespace()
  -- Save cursor position
  local save_pos = vim.api.nvim_win_get_cursor(0)

  -- Remove trailing whitespace from all lines
  vim.cmd([[ %s/\s\+$//e ]])

  -- Restore cursor position
  vim.api.nvim_win_set_cursor(0, save_pos)
end

-- Create a user command if you want to call it with :StripTrailingWhitespace
vim.api.nvim_create_user_command("StripTrailingWhitespace", strip_trailing_whitespace, {})


local function format_json()
  local start_line, end_line
  local mode = vim.api.nvim_get_mode().mode

  -- Get selected range or whole buffer
  if mode == 'v' or mode == 'V' or mode == '' then  -- visual modes
    local start_pos = vim.fn.getpos("'<")
    local end_pos = vim.fn.getpos("'>")
    start_line = start_pos[2]
    end_line = end_pos[2]
  else
    start_line = 1
    end_line = vim.api.nvim_buf_line_count(0)
  end

  -- ensure at least one line
  if start_line > end_line then
      start_line, end_line = end_line, start_line
  end

  -- Get lines in range
  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
  if #lines == 0 then
    print("No text selected or in buffer.")
    return
  end

  -- Join lines for stdin
  local text = table.concat(lines, "\n")

  -- Use system python to format JSON, capture output and errors
  local output = vim.fn.system({'python3', '-m', 'json.tool'}, text)
  local ret = vim.v.shell_error

  if ret == 0 then
    -- Success, replace text with formatted JSON lines
    local formatted_lines = {}
    for line in output:gmatch("[^\r\n]+") do
      table.insert(formatted_lines, line)
    end

    vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, false, formatted_lines)
  else
    -- Error occurred, show error message
    print("JSON formatting error: " .. output)
  end
end

-- Map it to a command for easy use
vim.api.nvim_create_user_command("FormatJSON", format_json, {})

