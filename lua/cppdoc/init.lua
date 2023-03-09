local M = {}

M.config = {
    install_dir = vim.fn.stdpath("data") .. "/cppdoc",
    -- hard coded latest release
    -- dosen't chage often though
    download_link = "https://github.com/PeterFeicht/cppreference-doc/releases/download/v20220730/html-book-20220730.tar.xz"
}

local function file_exists(path)
    local f = io.open(path, "r")
    return f ~= nil and io.close(f)
end

function M.setup(config)
    M.config = vim.tbl_extend("force", M.config, config or {})

    if file_exists(M.config.install_dir .. "/index.txt")
    then
        return
    else
        if not os.execute("cd " .. M.config.install_dir .. "/reference/en && find . -name '*.html' -printf '%P\n' > ../../index.txt")
        then
            vim.notify("Failed to index the cppreference html book")
            return
        end
    end

    if not file_exists(M.config.install_dir .. "/downloaded")
    then
        os.execute("mkdir -p " .. M.config.install_dir)
        if os.execute("curl -L " .. M.config.download_link .. " | tar -C " .. M.config.install_dir .. " --xz -x")
        then
            os.execute("touch " .. M.config.install_dir .. "/downloaded")
        else
            vim.notify("Failed to download the cppreference html book")
            return
        end
    end
end

function M.open()
    -- but it works
    vim.cmd("terminal RESP=$(cat "..M.config.install_dir.."/index.txt | fzf);if [ $? -ne 130 ]; then; xdg-open "..M.config.install_dir.."/reference/en/$RESP;fi")
    vim.cmd("normal! i")
end

return M

