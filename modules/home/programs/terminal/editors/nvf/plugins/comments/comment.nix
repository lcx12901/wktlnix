{ lib, ... }:
let
  inherit (lib.generators) mkLuaInline;
in
{
  programs.nvf.settings = {
    vim.comments.comment-nvim = {
      enable = true;

      setupOpts = {
        opleader = {
          block = "gb";
          line = "gc";
        };

        toggler = {
          block = "gbc";
          line = "gcc";
        };

        extra = {
          above = "gcO";
          below = "gco";
          eol = "gcA";
        };

        pre_hook = mkLuaInline "require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook()";
      };
    };
  };
}
