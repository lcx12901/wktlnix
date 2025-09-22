{ lib, pkgs, ... }:
let
  inherit (lib.nvim.binds) mkKeymap;
in
{
  programs.nvf.settings = {
    vim = {
      lazy.plugins.goto-preview = {
        package = pkgs.vimPlugins.goto-preview;
        setupModule = "goto-preview";
        event = "BufEnter";
      };

      keymaps = [
        (mkKeymap "n" "<leader>gpd" "<cmd>lua require('goto-preview').goto_preview_definition()<CR>" {
          desc = "goto_preview_definition";
        })
        (mkKeymap "n" "<leader>gpt" "<cmd>lua require('goto-preview').goto_preview_type_definition()<CR>" {
          desc = "goto_preview_type_definition";
        })
        (mkKeymap "n" "<leader>gpi" "<cmd>lua require('goto-preview').goto_preview_implementation()<CR>" {
          desc = "goto_preview_implementation";
        })
        (mkKeymap "n" "<leader>gpD" "<cmd>lua require('goto-preview').goto_preview_declaration()<CR>" {
          desc = "goto_preview_declaration";
        })
        (mkKeymap "n" "<leader>gP" "<cmd>lua require('goto-preview').close_all_win()<CR>" {
          desc = "close_all_win";
        })
        (mkKeymap "n" "<leader>gpr" "<cmd>lua require('goto-preview').goto_preview_references()<CR>" {
          desc = "goto_preview_references";
        })
      ];
    };
  };
}
