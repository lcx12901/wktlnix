{
  helpers,
  lib,
  ...
}:
{
  globals = {
    mapleader = " ";
    maplocalleader = " ";
  };

  keymaps =
    let
      normal =
        lib.mapAttrsToList
          (
            key:
            { action, ... }@attrs:
            {
              mode = "n";
              inherit action key;
              options = attrs.options or { };
            }
          )
          {
            "<Space>" = {
              action = "<NOP>";
            };

            # Esc to clear search results
            "<esc>" = {
              action = "<cmd>noh<CR>";
            };
          };
    in
    helpers.keymaps.mkKeymaps { options.silent = true; } normal;
}
