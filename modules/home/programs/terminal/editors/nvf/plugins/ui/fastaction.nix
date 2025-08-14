{ inputs, ... }:
let
  inherit (inputs.nvf.lib.nvim.binds) mkKeymap;
in
{
  programs.nvf.settings = {
    vim = {
      ui.fastaction = {
        enable = true;
      };

      keymaps = [
        (mkKeymap "n" "<leader>lc" ''<cmd>lua require('fastaction').code_action()<cr>'' {
          desc = "Fastaction code action";
        })
        (mkKeymap "v" "<leader>lc" ''<cmd>lua require('fastaction').range_code_action()<cr>'' {
          desc = "Fastaction code action";
        })
      ];
    };
  };
}
