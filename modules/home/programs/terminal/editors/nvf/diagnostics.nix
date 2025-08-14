{ lib, ... }:
let
  inherit (lib.generators) mkLuaInline;
in
{
  programs.nvf.settings = {
    vim.diagnostics = {
      enable = true;

      config = {
        update_in_insert = true;

        severity_sort = true;

        virtual_text = false;
        # virtual_text = {
        #   severity.min = "warn";
        #   source = "if_many";
        # };

        virtual_lines = false;
        # virtual_lines = {
        #   current_line = true;
        # };

        float = {
          border = "rounded";
        };

        jump = {
          severity = mkLuaInline "vim.diagnostic.severity.WARN";
        };

        signs = {
          text = mkLuaInline ''
            {
              [vim.diagnostic.severity.ERROR] = " ",
              [vim.diagnostic.severity.WARN] = " ",
              [vim.diagnostic.severity.INFO] = "󰋼 ",
              [vim.diagnostic.severity.HINT] = "󰌵 ",
            }
          '';
        };
      };
    };
  };
}
