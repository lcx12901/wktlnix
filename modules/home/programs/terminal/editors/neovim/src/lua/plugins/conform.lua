return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("conform").setup {
      formatters_by_ft = {
        lua = { "stylua" },
        -- typescript = { "eslint_d" },
        -- javascript = { "eslint_d" },
        -- typescriptreact = { "eslint_d" },
        -- vue = { "eslint_d" },
        -- css = { "eslint_d" },
        -- scss = { "eslint_d" },
        -- less = { "eslint_d" },
        -- json = { "eslint_d" },
        -- jsonc = { "eslint_d" },
        -- html = { "eslint_d" },
        nix = { "alejandra" },
      },
      formatters = {
        -- eslint_d = {
        --   command = "eslint_d",
        --   args = { "--fix-to-stdout", "--stdin", "--stdin-filename", "$FILENAME" },
        --   cwd = require("conform.util").root_file { "package.json" },
        -- },
      },
    }

    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = "*",
      callback = function(args) require("conform").format { bufnr = args.buf, lsp_fallback = true } end,
    })
  end,
}
