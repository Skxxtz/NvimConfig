vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- Move lines up or down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Join line below with this one but having cursor stay in place
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "K", "i<CR><Esc>k$")


-- Keep search terms in the middle
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")


-- Jump to top/bottom with cursor in middle
vim.keymap.set("n", "G", "Gzz")

-- Paste without losing pasted word
vim.keymap.set("x", "<leader>p", "\"_dP")


-- Sets <leader>y to yank into system clipboard, else into internal buffer
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>y", "\"+Y")

-- quick fix navigation
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")


-- replace all occurrences of word under cursor
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- make bash script executeable
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })


-- Git keybind
vim.keymap.set("n", "<leader>gc", function()
    vim.fn.system("git add .")
    local commit = vim.fn.input("commit message: ")
    ClearTerm()
    local output = vim.fn.system(string.format('git commit -m "%s"', commit))
    PrintOutput(output)
end, { silent = true })

vim.keymap.set("n", "<leader>gp", function()
    ClearTerm()
    local output = vim.fn.system("git push");
    PrintOutput(output)
end, { silent = true })

vim.keymap.set("n", "<leader>get", function()
    local output = vim.fn.system("git pull");
    PrintOutput(output)
end, { silent = true })


-- Compiler Commands
vim.keymap.set("n", "<leader>ö", function()
    local cfile = vim.fn.expand("%:t:r")
    local extension = vim.fn.expand("%:t:e")
    if extension == "rs" then
        vim.cmd("! cargo run\n")
    elseif extension == "cpp" then
        local command
        if PLATFORM == "Windows_NT" then
            command = string.format(".\\ %s.exe\n", cfile)
        else
            command = string.format("! ./%s\n", cfile)
        end
        vim.cmd(command)
    elseif extension == "py" then
        vim.cmd(string.format("! python %s.py\n", cfile))
    end
end)

vim.keymap.set("n", "<leader>ü", function()
    local current_file = vim.fn.expand("%:t")
    local cfile = vim.fn.expand("%:t:r")
    local extension = vim.fn.expand("%:t:e")
    if extension == "rs" then
        vim.cmd("! cargo build\n")
    elseif extension == "cpp" then
        local command
        if CPP_COMPILER == "clang++" then
            command = string.format("! clang++ %s -o %s.exe\n", current_file, cfile)
        elseif CPP_COMPILER == "g++" then
            command = string.format("! g++ %s -o %s\n", current_file, cfile)
        end
        vim.cmd(command)
    end
end)


-- Unbind Q
vim.keymap.set("n", "Q", "<nop>")
