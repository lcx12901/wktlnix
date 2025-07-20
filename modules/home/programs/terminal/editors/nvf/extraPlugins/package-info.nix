{ inputs, pkgs, ... }:
let
  inherit (inputs.nvf.lib.nvim.binds) mkKeymap;
in
{
  programs.nvf.settings = {
    vim = {
      lazy.plugins."package-info.nvim" = {
        package = pkgs.vimPlugins.package-info-nvim;
        setupModule = "package-info";
        event = [ "BufRead package.json" ];
        setupOpts = {
          hide_up_to_date = true;
        };
      };

      keymaps = [
        (mkKeymap "n" "<leader>fP" "<cmd>Telescope package_info<CR>" { desc = "Find package info"; })
      ];
    };
  };
}
