{ lib, ... }:
let
  inherit (lib.nvim.binds) mkKeymap;
in
{
  programs.nvf.settings = {
    vim.terminal.toggleterm = {
      enable = true;
      setupOpts = {
        direction = "float";
        shading_factor = 2;
        float_opts.border = "rounded";
      };
    };

    vim.keymaps = [
      (mkKeymap "n" "<F7>" ''<cmd>execute v:count . "ToggleTerm"<CR>'' { desc = "Open terminal"; })
      (mkKeymap [ "i" "t" ] "<F7>" "<Cmd>ToggleTerm<CR>" { desc = "Open terminal"; })
      (mkKeymap "t" "<Esc><Esc>" "<C-\\><C-n>" { desc = "Switch to normal mode"; })
    ];
  };
}
