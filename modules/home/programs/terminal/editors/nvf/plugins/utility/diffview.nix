{ lib, ... }:
let
  inherit (lib.nvim.binds) mkKeymap;
in
{
  programs.nvf.settings = {
    vim = {
      utility.diffview-nvim.enable = true;

      keymaps = [
        (mkKeymap "n" "<leader>gd" "<cmd>DiffviewOpen<cr>" {
          desc = "Git Diff";
          silent = true;
        })
        (mkKeymap "n" "<leader>gD" "<cmd>DiffviewOpen FETCH_HEAD<cr>" {
          desc = "Git Diff HEAD";
          silent = true;
        })
      ];
    };
  };
}
