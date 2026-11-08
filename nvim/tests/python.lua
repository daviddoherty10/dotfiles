-- Real Jedi integration: standalone files and dependencies inside an unactivated .venv.
local tmp = vim.fn.tempname()
local active = vim.env.VIRTUAL_ENV
local conda = vim.env.CONDA_PREFIX
local ok, err = xpcall(function()
    if package.loaded["lazy"] then
        require("lazy").load({ plugins = { "nvim-lspconfig" } })
    end
    require("config.lsp").setup()
    assert(
        vim.fn.executable("jedi-language-server") == 1,
        "Run :MasonInstall jedi-language-server first"
    )
    local python = assert(require("config.python").interpreter(nil), "Python is missing")
    vim.env.VIRTUAL_ENV = nil
    vim.env.CONDA_PREFIX = nil
    vim.fn.mkdir(tmp .. "/project", "p")
    local result = vim.system(
        { python, "-m", "venv", "--without-pip", tmp .. "/project/.venv" },
        { text = true }
    ):wait()
    assert(result.code == 0, result.stderr)
    local project_python = assert(require("config.python").interpreter(tmp .. "/project"))
    result = vim.system(
        { project_python, "-c", "import sysconfig; print(sysconfig.get_path('purelib'))" },
        { text = true }
    ):wait()
    assert(result.code == 0, result.stderr)
    local site = vim.trim(result.stdout)
    vim.fn.writefile(
        { "def unique_project_function():", "    return 42" },
        site .. "/nvim_lsp_test_dependency.py"
    )
    vim.lsp.enable("jedi_language_server")

    local function open(path, lines)
        vim.fn.writefile(lines, path)
        vim.cmd.edit(path)
        local buf = vim.api.nvim_get_current_buf()
        local client
        assert(
            vim.wait(15000, function()
                client = vim.lsp.get_clients({ bufnr = buf, name = "jedi_language_server" })[1]
                return client and client.initialized
            end, 50),
            "Jedi did not attach to " .. path
        )
        return buf, client
    end
    local function completion(buf, client, line, character, label)
        local reply = assert(client:request_sync("textDocument/completion", {
            textDocument = { uri = vim.uri_from_bufnr(buf) },
            position = { line = line, character = character },
        }, 10000, buf))
        assert(not reply.err, vim.inspect(reply.err))
        local items = reply.result and (reply.result.items or reply.result) or {}
        assert(
            vim.iter(items):any(function(item)
                return item.label == label
            end),
            "Missing completion: " .. label
        )
    end
    local function stop(client)
        client:stop()
        vim.wait(3000, function()
            return client:is_stopped()
        end, 50)
        vim.cmd("bwipeout!")
    end

    local buf, client = open(tmp .. "/standalone.py", { "import math", "math.sq" })
    completion(buf, client, 1, 7, "sqrt")
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "def broken(:", "    return 1" })
    assert(
        vim.wait(5000, function()
            return #vim.diagnostic.get(buf) > 0
        end, 50),
        "Syntax diagnostics missing"
    )
    stop(client)
    print("PASS: standalone Python attachment, completion, syntax diagnostics")

    buf, client = open(
        tmp .. "/project/main.py",
        { "import nvim_lsp_test_dependency", "nvim_lsp_test_dependency.unique_" }
    )
    assert(
        client.config.init_options.workspace.environmentPath == project_python,
        "Wrong project interpreter"
    )
    completion(buf, client, 1, #"nvim_lsp_test_dependency.unique_", "unique_project_function")
    local reply = assert(client:request_sync("textDocument/definition", {
        textDocument = { uri = vim.uri_from_bufnr(buf) },
        position = { line = 0, character = 10 },
    }, 10000, buf))
    assert(
        not reply.err and reply.result and #reply.result > 0,
        "Project import definition missing"
    )
    stop(client)
    print("PASS: project .venv detection, dependency completion and definition")
    vim.env.VIRTUAL_ENV = tmp .. "/project/.venv"
    assert(
        require("config.python").interpreter(tmp) == project_python,
        "Activated environment ignored"
    )
    print("PASS: activated environment takes priority")
end, debug.traceback)
vim.env.VIRTUAL_ENV = active
vim.env.CONDA_PREFIX = conda
for _, client in ipairs(vim.lsp.get_clients()) do
    client:stop()
end
vim.fn.delete(tmp, "rf")
if not ok then
    io.stderr:write(err .. "\n")
    vim.cmd("cquit 1")
end
vim.cmd("qa!")
