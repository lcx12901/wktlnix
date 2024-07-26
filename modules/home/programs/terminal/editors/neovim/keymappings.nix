{
  config,
  lib,
  ...
}: {
  programs.nixvim = {
    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };

    /*
    *
      mapAttrsToList (name: value: name + value) { x = "a"; y = "b"; }
      => [ "xa" "yb" ]
    */
    keymaps = let
      normal =
        lib.mapAttrsToList (key: {action, ...} @ attrs: {
          mode = "n";
          inherit action key;
          options = attrs.options or {};
        }) {
          "<Space>" = {
            action = "<NOP>";
          };

          # Esc to clear search results
          "<esc>" = {
            action = ":noh<CR>";
          };

          # Backspace delete in normal
          "<BS>" = {
            action = "<BS>x";
          };
        };
    in
      config.lib.nixvim.keymaps.mkKeymaps {options.silent = true;} normal;
  };
}
