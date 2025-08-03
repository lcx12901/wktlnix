{ inputs, ... }:
let
  inherit (inputs.nvf.lib.nvim.binds) mkKeymap;
in
{
  programs.nvf.settings = {
    vim = {
      ui.colorizer = {
        enable = true;

        setupOpts = {
          user_default_options = {
            css = true;
            tailwind = true;
            mode = "foreground";
          };
        };
      };
      keymaps = [
        (mkKeymap "n" "<leader>uC"
          ''
            function ()
             vim.g.colorizing_enabled = not vim.g.colorizing_enabled
             vim.cmd('ColorizerToggle')
            end
          ''
          {
            desc = "Colorizing toggle";
            silent = true;
          }
        )
      ];
    };
  };
}
