{ lib, pkgs, ... }:
let
  inherit (lib.generators) mkLuaInline;
in
{
  programs.nvf.settings = {
    vim = {
      lazy.plugins."nvim-highlight-colors" = {
        package = pkgs.vimPlugins.nvim-highlight-colors;
        setupModule = "nvim-highlight-colors";
        event = "InsertEnter";
        cmd = "HighlightColors";
        setupOpts = {
          enable_named_colors = false;
          virtual_symbol = "󱓻";
          exclude_buffer = mkLuaInline ''
            function(bufnr) return vim.fn.getfsize(vim.api.nvim_buf_get_name(bufnr)) > 1000000 end
          '';
        };
      };
    };
  };
}
