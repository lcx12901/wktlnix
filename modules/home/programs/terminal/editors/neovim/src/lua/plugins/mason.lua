-- Customize Mason plugins
--
-- NOTE: Issue - mason.nvim does not support NixOS:
-- https://github.com/williamboman/mason.nvim/issues/428

---@type LazySpec
return {
  -- use mason-lspconfig to configure LSP installations
  {
    "williamboman/mason-lspconfig.nvim",
    -- mason is unusable on NixOS, disable it.
    -- ensure_installed nothing
    opts = function(_, opts)
      -- vue-language-server install by nixpkgs, not normal run, so by the mesaon
      opts.ensure_installed = nil
      opts.automatic_installation = false
    end,
  },
  -- use mason-null-ls to configure Formatters/Linter installation for null-ls sources
  {
    "jay-babu/mason-null-ls.nvim",
    -- mason is unusable on NixOS, disable it.
    -- ensure_installed nothing
    opts = function(_, opts)
      opts.ensure_installed = nil
      opts.automatic_installation = false
    end,
  },
  {
    -- https://docs.astronvim.com/recipes/dap/
    "jay-babu/mason-nvim-dap.nvim",
    -- mason is unusable on NixOS, disable it.
    -- ensure_installed nothing
    opts = function(_, opts)
      opts.ensure_installed = nil
      opts.automatic_installation = false
    end,
  },
}
