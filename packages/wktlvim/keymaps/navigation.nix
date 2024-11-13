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
        "<C-H>" = {
          action = "<C-w>h";
          options.desc = "Move to left split";
        };
        "<C-J>" = {
          action = "<C-w>j";
          options.desc = "Move to below split";
        };
        "<C-K>" = {
          action = "<C-w>k";
          options.desc = "Move to above split";
        };
        "<C-L>" = {
          action = "<C-w>l";
          options.desc = "Move to right split";
        };
        "<C-Up>" = {
          action = "<Cmd>resize -2<CR>";
          options.desc = "Resize split up";
        };
        "<C-Down>" = {
          action = "<Cmd>resize +2<CR>";
          options.desc = "Resize split down";
        };
        "<C-Left>" = {
          action = "<Cmd>vertical resize -2<CR>";
          options.desc = "Resize split left";
        };
        "<C-Right>" = {
          action = "<Cmd>vertical resize +2<CR>";
          options.desc = "Resize split right";
        };
      };
  in
    helpers.keymaps.mkKeymaps {options.silent = true;} normal;
}
