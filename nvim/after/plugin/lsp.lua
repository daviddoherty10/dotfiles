local lsp_zero = require('lsp-zero')


-- On attach function
lsp_zero.on_attach(function(client, bufnr)
    lsp_zero.default_keymaps({ buffer = bufnr })

    -- Ensure formatting on save works only for clangd
    if client.name == "clangd" then
        vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.format({ async = false })
            end,
        })
    end
end)

-- Mason and LSP server setup
require('mason').setup({})
require('mason-lspconfig').setup({
    ensure_installed = { 'svelte' ,'rome', 'eslint', 'jsonls', 'jdtls', 'jedi_language_server', 'tailwindcss', 'html', 'clangd', 'emmet_language_server', 'cssls', 'gopls', 'docker_compose_language_service' },
    handlers = {
        lsp_zero.default_setup,
    }
})

-- CMP (Comletion) settings
local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp_zero.defaults.cmp_mappings({
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ["<C-Space>"] = cmp.mapping.complete(),
})

-- Disable Tab and Shift-Tab for cycling completion
cmp_mappings['<Tab>'] = nil
cmp_mappings['<S-Tab>'] = nil

-- Format on save for all languages
lsp_zero.format_on_save({
    format_opts = {
        async = false,
        timeout_ms = 10000,
    },
    servers = { 'clangd'} -- Ensure clangd is included for format-on-save
})

-- Final setup
lsp_zero.setup()
