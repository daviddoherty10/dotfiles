local M = {}
function M.check()
    vim.health.start("Neovim config prerequisites")
    for _, tool in ipairs({ "git", "rg", "node", "npm", "python3", "go", "cc", "tree-sitter" }) do
        if vim.fn.executable(tool) == 1 then
            vim.health.ok(tool .. " found")
        else
            vim.health.error(tool .. " missing; see README.md installation requirements")
        end
    end
    vim.health.start("Python language server")
    -- Health can also run before any code buffer has loaded the Mason plugin.
    pcall(require, "mason")
    if vim.fn.executable("jedi-language-server") == 1 then
        vim.health.ok("jedi-language-server: " .. vim.fn.exepath("jedi-language-server"))
    else
        vim.health.error(
            "jedi-language-server is missing; run :MasonInstall jedi-language-server and check :MasonLog"
        )
    end
    local bufnr = vim.fn.bufnr("#")
    if bufnr < 1 or vim.bo[bufnr].filetype ~= "python" then
        bufnr = vim.api.nvim_get_current_buf()
    end
    local python = require("config.python")
    local interpreter = python.interpreter(python.root(bufnr))
    if interpreter then
        vim.health.ok("Analysis interpreter: " .. interpreter)
    end
    local clients = vim.lsp.get_clients({ name = "jedi_language_server" })
    if #clients == 0 then
        vim.health.warn("Jedi is not attached; open a Python file and inspect :LspInfo / :MasonLog")
    else
        for _, client in ipairs(clients) do
            vim.health.ok("Jedi attached: " .. (client.root_dir or "standalone file"))
        end
    end
    vim.health.info(
        "Jedi reports syntax errors; undefined names and type errors require a linter/type checker."
    )

    vim.health.start("Java runtime")
    local java = vim.env.JDTLS_JAVA_HOME and (vim.env.JDTLS_JAVA_HOME .. "/bin/java") or "java"
    local found, process = pcall(vim.system, { java, "-version" }, { text = true })
    if not found then
        vim.health.error("Java executable missing; set JDTLS_JAVA_HOME (see README.md)")
        return
    end
    local result = process:wait()
    local output = (result.stderr or "") .. (result.stdout or "")
    local major = tonumber(output:match('version "(%d+)') or output:match("openjdk (%d+)"))
    if result.code == 0 and major and major >= 21 then
        vim.health.ok("JDT LS Java runtime: " .. major)
    else
        vim.health.error("JDT LS requires Java 21+; set JDTLS_JAVA_HOME (see README.md)")
    end
end
return M
