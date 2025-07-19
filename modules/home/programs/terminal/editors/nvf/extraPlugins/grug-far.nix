{ inputs, pkgs, ... }:
let
  inherit (inputs.nvf.lib.nvim.binds) mkKeymap;
in
{
  programs.nvf.settings = {
    vim = {
      lazy.plugins."grug-far.nvim" = {
        package = pkgs.vimPlugins.grug-far-nvim;
        setupModule = "grug-far";
        cmd = [ "GrugFar" ];
      };

      keymaps = [
        (mkKeymap "n" "<leader>rg" "<cmd>GrugFar<CR>" { desc = "GrugFar toggle"; })
      ];
    };
  };
}
