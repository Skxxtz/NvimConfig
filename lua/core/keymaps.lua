vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", {desc = "Move line(s) down one line."})
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", {desc = "Move line(s) up one line."})

vim.keymap.set("n", "J", "mzJ`z", {desc = "Join the line below to this with the cursor staying in the same position."})

vim.keymap.set("n", "n", "nzzzv", {desc = "Next search result, but keep the cursor in the middle."})
vim.keymap.set("n", "N", "Nzzzv", {desc = "Previous search result, but keep the cursor in the middle."})

vim.keymap.set("n", "G", "Gzz", {desc = "Jump to the bottom with the cursor in the middle."})

vim.keymap.set("x", "<leader>p", "\"_dP", {desc="Put text [from register x] before the cursor without adding a replaced string [into register x].."})

vim.keymap.set("n", "<leader>y", "\"+y", {desc="Yank into system clipboard."})
vim.keymap.set("v", "<leader>y", "\"+y", {desc="Yank into system clipboard."})
vim.keymap.set("n", "<leader>y", "\"+Y", {desc="Yank into system clipboard."})

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz", {desc="Quick fix navigation"})
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz", {desc="Quick fix navigation"})
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz", {desc="Quick fix navigation"})
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz", {desc="Quick fix navigation"})


vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], {desc="Replace all occurrences of word under cursor."})

vim.keymap.set("n", "<leader>gc", function()
    vim.fn.system("git add .")
    local commit = vim.fn.input("commit message: ")
    local output = vim.fn.system(string.format('git commit -m "%s"', commit))
    PrintOutput(output)
end, { silent = true, desc="Git add all and commit with message."})

vim.keymap.set("n", "<leader>gp", function()
    local output = vim.fn.system("git push");
    PrintOutput(output)
end, { silent = true, desc="Git push" })

vim.keymap.set("n", "<leader>get", function()
    vim.fn.system("git stash");
    local output = vim.fn.system("git pull --rebase");
    vim.fn.system("git stash pop");
    PrintOutput(output)
end, { silent = true, desc="Git stash current edits and pull from remote." })


vim.keymap.set("n", "<leader>ö", ":lua RunCompiledProgram()<CR>", { silent = true, desc="Runs py, rs, c++, sh programs (if compiled)." })

vim.keymap.set("n", "<leader>ü", function()
    local current_file = vim.fn.expand("%:p")
    local cfile = vim.fn.expand("%:t:r")
    local extension = vim.fn.expand("%:t:e")
    if extension == "rs" then
        vim.cmd(":silent ! cargo build\n")
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
    end
end, { silent = true, desc="Compiles or makes executable all rs, c++, sh files." })


vim.keymap.set("n", "Q", "<nop>", {desc="Unbinds Q."})


vim.keymap.set("n", "<Esc>", ":echo ''<CR>", {desc="Clear command line."})
