{ lib, pkgs, ... }:
let
  inherit (lib.nvim.binds) mkKeymap;
in
{
  programs.nvf.settings = {
    vim = {
      lazy.plugins."glance.nvim" = {
        package = pkgs.vimPlugins.glance-nvim;
        setupModule = "glance";
        cmd = "Glance";
      };

      binds.whichKey.register = {
        "<leader>lg" = "Glance";
      };

      keymaps = [
        (mkKeymap "n" "<leader>lgd" "<CMD>Glance definitions<CR>" { desc = "Glance definition"; })
        (mkKeymap "n" "<leader>lgi" "<CMD>Glance implementations<CR>" { desc = "Glance implementation"; })
        (mkKeymap "n" "<leader>lgr" "<CMD>Glance references<CR>" { desc = "Glance reference"; })
        (mkKeymap "n" "<leader>lgt" "<CMD>Glance type_definitions<CR>" { desc = "Glance type definition"; })
      ];
    };
  };
}
