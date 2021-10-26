-- Improve the return
local M = {}
-- Load the modules
local lsp_installer = require 'nvim-lsp-installer'
local utils = require 'util'
local capabilities = vim.lsp.protocol.make_client_capabilities()
-- Set the nvim-lsp capabilities
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

-- On on_attach function
local on_attach = function(_client, bufnr)
  utils.set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  local buf_set_keymap = function(...)
    local opts = { noremap = true, silent = true }
    vim.api.nvim_set_keymap(bufnr, ..., opts)
  end
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>')
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>')
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>')
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>')
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>')
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>')
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>')
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>')
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>')
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>')
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>')
  buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>')
end

local function setup_handlers()
  vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = {
      prefix = '●',
    },
    signs = true,
    underline = true,
    update_in_insert = false,
  })
end

local function setup_icons_errors()
  local signs = { Error = ' ', Warning = ' ', Hint = ' ', Information = ' ' }

  for type, icon in pairs(signs) do
    local hl = 'LspDiagnosticsSign' .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
  end
end

function M.setup()
  setup_handlers()
  setup_icons_errors()
  vim.cmd [[ command! LspLog tabnew|lua vim.cmd('e '..vim.lsp.get_log_path()) ]]

  lsp_installer.on_server_ready(function(server)
    local opts = {
      on_attach = on_attach,
      capabilities = capabilities,
    }

    server:setup(opts)
    vim.cmd [[ do User LspAttachBuffers ]]
  end)
end

return M
