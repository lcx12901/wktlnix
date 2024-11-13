{
  helpers,
  lib,
  ...
}: {
  keymaps = let
    normal =
      lib.mapAttrsToList (
        key: {action, ...} @ attrs: {
          mode = "n";
          inherit action key;
          options = attrs.options or {};
        }
      ) {
        "j" = {
          action = "v:count == 0 ? 'gj' : 'j'";
          options.desc = "Move cursor down";
          expr = true;
        };
        "k" = {
          action = "v:count == 0 ? 'gk' : 'k'";
          options.desc = "Move cursor up";
          expr = true;
        };
        "<Leader>w" = {
          action = "<Cmd>w<CR>";
          options.desc = "Save file";
        };
        "<Leader>q" = {
          action = "<Cmd>confirm q<CR>";
          options.desc = "Quit Window";
        };
        "<Leader>Q" = {
          action = "<Cmd>confirm qall<CR>";
          options.desc = "Exit wktlNvim";
        };
        "<Leader>n" = {
          action = "<Cmd>enew<CR>";
          options.desc = "New file";
        };
        "<C-S>" = {
          action = "<Cmd>silent! update! | redraw<CR>";
          options.desc = "Force write";
        };
      };
  in
    helpers.keymaps.mkKeymaps {options.silent = true;} normal;
}
