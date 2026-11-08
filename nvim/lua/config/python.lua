local M = {}

function M.root(bufnr)
    local name = vim.api.nvim_buf_get_name(bufnr)
    if name == "" then
        return vim.fn.getcwd()
    end
    return vim.fs.root(bufnr, {
        "pyproject.toml",
        "setup.py",
        "setup.cfg",
        "requirements.txt",
        "Pipfile",
        ".venv",
        "venv",
        ".git",
    }) or vim.fs.dirname(name)
end

local function environment_python(directory)
    if not directory or directory == "" then
        return
    end
    for _, relative in ipairs({ "bin/python", "Scripts/python.exe" }) do
        local path = vim.fs.joinpath(directory, relative)
        if vim.fn.executable(path) == 1 then
            return path
        end
    end
end

function M.interpreter(root)
    -- An explicitly activated environment wins. Otherwise find the project's
    -- environment instead of analysing imports in Mason's private server venv.
    local active = environment_python(vim.env.VIRTUAL_ENV)
    if active then
        return active
    end
    if root then
        for _, name in ipairs({ ".venv", "venv" }) do
            local python = environment_python(vim.fs.joinpath(root, name))
            if python then
                return python
            end
        end
    end
    local conda = environment_python(vim.env.CONDA_PREFIX)
    if conda then
        return conda
    end
    for _, command in ipairs({ "python3", "python" }) do
        local path = vim.fn.exepath(command)
        if path ~= "" then
            return path
        end
    end
end

function M.before_init(params, config)
    local python = M.interpreter(config.root_dir)
    if not python then
        return
    end
    params.initializationOptions =
        vim.tbl_deep_extend("force", params.initializationOptions or {}, {
            workspace = { environmentPath = python },
        })
    config.init_options = params.initializationOptions
end

return M
