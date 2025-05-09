local set = vim.keymap.set
vim.g.mapleader = " "
vim.g.maplocalleader = " "
set("n", "<leader>pv", vim.cmd.Ex)

set("v", "J", ":m '>+1<CR>gv=gv", {desc = "Move line(s) down one line."})
set("v", "K", ":m '<-2<CR>gv=gv", {desc = "Move line(s) up one line."})

set("n", "J", "mzJ`z", {desc = "Join the line below to this with the cursor staying in the same position."})

set("n", "n", "nzzzv", {desc = "Next search result, but keep the cursor in the middle."})
set("n", "N", "Nzzzv", {desc = "Previous search result, but keep the cursor in the middle."})


set("n", "<leader>o","printf('m%so<ESC>``', v:count1)", {expr = true, desc = "Insert line below current line."})
set("n", "<leader>O","printf('m%sO<ESC>``', v:count1)", {expr = true, desc = "Insert line above current line."})

set("n", "G", "Gzz", {desc = "Jump to the bottom with the cursor in the middle."})

set("x", "<leader>p", "\"_dP", {desc="Put text [from register x] before the cursor without adding a replaced string [into register x].."})

set("n", "<leader>y", "\"+y", {desc="Yank into system clipboard."})
set("v", "<leader>y", "\"+y", {desc="Yank into system clipboard."})
set("n", "<leader>y", "\"+Y", {desc="Yank into system clipboard."})

set("n", "<C-k>", "<cmd>cprev<CR>zz", {desc="Quick fix navigation"})
set("n", "<C-j>", "<cmd>cnext<CR>zz", {desc="Quick fix navigation"})
set("n", "<leader>k", "<cmd>lprev<CR>zz", {desc="Quick fix navigation"})
set("n", "<leader>j", "<cmd>lnext<CR>zz", {desc="Quick fix navigation"})

-- Move the cursor based on physical lines, not actual lines.
set("n", "j", "v:count == 0 ? 'gj' : 'j'", {expr = true})
set("n", "k", "v:count == 0 ? 'gk' : 'k'", {expr = true})
set("n", "H", "0")
set("n", "L", "g_")

-- Center after moving down or up
set("n", "<C-d>", "<C-d>zz", {desc="Center content after moving half page down"})
set("n", "<C-u>", "<C-u>zz", {desc="Center content after moving half page up"})

-- Shifting won't deselect lines
set("x", "<", "<gv")
set("x", ">", ">gv")

-- Create undo break points
local undo_ch = {",", ".", "!", "?", ";", ":"}
for _, ch in ipairs(undo_ch) do
    set("i", ch, ch .. "<c-g>u")
end

-- Add semicolon at the line end
set("i", "<A-;>", "<Esc>miA;<Esc>`ii")

-- Format JSON files
set("n", "<C-H>", "<cmd>:%!python -m json.tool<CR>", {desc="Uses python to format json files"})
set("v", "<C-H>", ":'<,'>!python3 -m json.tool<CR>", {desc="Uses python to format json files"})


-- Change text without putting it into a register
set("n", "c", '"_c')
set("x", "c", '"_c')
set("n", "cc", '"_cc')
set("n", "C", '"_C')

-- Switch Windows (also build habit to use hjkl)
set("n", "<left>", "<c-w>h")
set("n", "<right>", "<c-w>l")
set("n", "<up>", "<c-w>k")
set("n", "<down>", "<c-w>j")

-- Close quick fix buffer on esc
vim.api.nvim_create_autocmd("FileType", {
    pattern = "qf",
    callback = function()
        vim.keymap.set("n", "<esc>", ":cclose<CR>", { buffer = true, silent = true })
    end
})

-- Remove trailing whitespaces
set("n", "<leader><leader>", "<cmd>StripTrailingWhitespace<CR>", {desc = "remove trailing space"})

set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], {desc="Replace all occurrences of word under cursor."})

set("n", "<leader>ö", ":lua RunCompiledProgram()<CR>", { silent = true, desc="Runs py, rs, c++, sh programs (if compiled)." })

set("n", "<leader>ü", function()
    local current_file = vim.fn.expand("%:p")
    local cfile = vim.fn.expand("%:t:r")
    local extension = vim.fn.expand("%:t:e")
    if extension == "rs" then
        vim.cmd("! cargo build\n")
    elseif extension == "cpp" then
        local executeable_ext = ""
        local command
        if UserSettings.Os.Platform == "Windows_NT" then
            executeable_ext = ".exe"
        end
        vim.cmd [[:w]]
        command = string.format("! %s %s %s -o %s%s", UserSettings.Cpp.Compiler, UserSettings.Cpp.Version, current_file, cfile, executeable_ext)
        vim.cmd(command)
    elseif extension == "sh" and UserSettings.Os.Platform ~= "Windows_NT" then
        vim.cmd(string.format("!chmod +x %s", current_file))
    elseif extension == "ts" then
        vim.cmd("!npx tsc")
    end
end, { silent = true, desc="Compiles or makes executable all rs, c++, sh files." })


set("n", "Q", "<nop>", {desc="Unbinds Q."})

set("n", "<F11>", "<cmd>set spell!<CR>", {desc="Toggle Spell"})
set("i", "<F11>", "<cmd>set spell!<CR>", {desc="Toggle Spell"})

set("n", "<Esc>", ":echo ''<CR>", {desc="Clear command line."})
set("n", "<C-#>", ":nohl<CR>:echo ''<CR>", {desc="Clear highlights. And commandline after."})
