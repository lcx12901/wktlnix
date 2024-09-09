return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("conform").setup {
      formatters_by_ft = {
        lua = { "stylua" },
        nix = { "alejandra" },
      },
    }

    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = "*",
      callback = function(args) require("conform").format { bufnr = args.buf, lsp_fallback = true } end,
    })
  end,
}
