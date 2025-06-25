local base = require("plugins.configs.lspconfig")
local on_attach = base.on_attach
local capabilities = base.capabilities

local lspconfig = require("lspconfig")
local util = require "lspconfig/util"

lspconfig.clangd.setup({
  on_attach = function(client, bufnr)
    client.server_capabilities.signatureHelpProvider = false
    on_attach(client, bufnr)
  end,
  capabilities=capabilities
})

lspconfig.gopls.setup({
  on_attach=on_attach,
  capabilities=capabilities,
  cmd={"gopls"},
  filetypes={"go", "gomod", "gowork", "gotmpl"},
  rootdir=util.root_pattern("go.work", "go.mod", ".git"),
  settings={
    gopls={
      completeUnimported=true,
      usePlaceholders=false,
      analyses={
        unusedparams=true
      }
    }
  }
})

local js_servers = {
  "ts_ls", "tailwindcss", "eslint", "cssls"
}

for _, lsp in ipairs(js_servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities
  }
end
