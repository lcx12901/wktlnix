-- AstroLSP allows you to customize the features in AstroNvim's LSP configuration engine
-- Configuration documentation can be found with `:h astrolsp`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

local customizations = {
  { rule = "style/*", severity = "off", fixable = true },
  { rule = "format/*", severity = "off", fixable = true },
  { rule = "*-indent", severity = "off", fixable = true },
  { rule = "*-spacing", severity = "off", fixable = true },
  { rule = "*-spaces", severity = "off", fixable = true },
  { rule = "*-order", severity = "off", fixable = true },
  { rule = "*-dangle", severity = "off", fixable = true },
  { rule = "*-newline", severity = "off", fixable = true },
  { rule = "*quotes", severity = "off", fixable = true },
  { rule = "*semi", severity = "off", fixable = true },
}

---@type LazySpec
return {
  "AstroNvim/astrolsp",
  ---@type AstroLSPOpts
  opts = {
    -- Configuration table of features provided by AstroLSP
    features = {
      autoformat = false, -- enable or disable auto formatting on start
      codelens = true, -- enable/disable codelens refresh on start
      inlay_hints = false, -- enable/disable inlay hints on start
      semantic_tokens = true, -- enable/disable semantic token highlighting
    },
    -- customize lsp formatting options
    formatting = {
      -- control auto formatting on save
      format_on_save = {
        enabled = false, -- enable or disable format on save globally
      },
      timeout_ms = 3000, -- default format timeout
      disabled = {
        "lua_ls",
        "nil_ls",
        "ts_ls",
        "volar",
        "eslint",
      },
    },
    -- enable servers that you already have installed without mason
    -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
    servers = {
      ---- Data & Configuration Languages
      "jsonls", -- json language server
      "jsonnet_ls", -- jsonnet language server
      "yamlls", -- yaml language server
      "taplo", -- toml language server
      "marksman", -- markdown ls
      "nil_ls", -- nix language server
      "bufls", -- protocol buffer language server
      "dockerls", -- dockerfile
      "cmake", -- cmake language server
      "sqls", -- sql language server

      ---- General Purpose Languages
      "lua_ls", -- lua
      "bashls", -- bash
      "rust_analyzer", -- rust

      ---- Web Development
      "ts_ls", -- typescript/javascript language server
      "volar", -- vue language server
      "cssls", -- css language server
      "prismals", -- prisma language server
      "eslint",
    },
    -- customize language server configuration options passed to `lspconfig`
    ---@diagnostic disable: missing-fields
    config = {
      eslint = {
        filetypes = {
          "javascript",
          "javascriptreact",
          "javascript.jsx",
          "typescript",
          "typescriptreact",
          "typescript.tsx",
          "vue",
          "html",
          "markdown",
          "json",
          "jsonc",
          "yaml",
          "toml",
          "xml",
          "gql",
          "graphql",
          "astro",
          "svelte",
          "css",
          "less",
          "scss",
          "pcss",
          "postcss",
        },
        settings = {
          -- Silent the stylistic rules in you IDE, but still auto fix them
          rulesCustomizations = customizations,
        },
      },
    },
    -- Configure buffer local auto commands to add when attaching a language server
    autocmds = {
      eslint_fix_on_save = false,
      -- first key is the `augroup` to add the auto commands to (:h augroup)
      lsp_document_highlight = {
        -- Optional condition to create/delete auto command group
        -- can either be a string of a client capability or a function of `fun(client, bufnr): boolean`
        -- condition will be resolved for each client on each execution and if it ever fails for all clients,
        -- the auto commands will be deleted for that buffer
        cond = "textDocument/documentHighlight",
        -- cond = function(client, bufnr) return client.name == "lua_ls" end,
        -- list of auto commands to set
        {
          -- events to trigger
          event = { "CursorHold", "CursorHoldI" },
          -- the rest of the autocmd options (:h nvim_create_autocmd)
          desc = "Document Highlighting",
          callback = function() vim.lsp.buf.document_highlight() end,
        },
        {
          event = { "CursorMoved", "CursorMovedI", "BufLeave" },
          desc = "Document Highlighting Clear",
          callback = function() vim.lsp.buf.clear_references() end,
        },
      },
    },
  },
}
