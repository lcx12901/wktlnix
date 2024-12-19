{
  helpers,
  lib,
  ...
}:
{
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
            # Navigate tabs
            "]t" = {
              action.__raw = ''
                function() vim.cmd.tabnext() end
              '';
              options.desc = "Next tab";
            };
            "[t" = {
              action.__raw = ''
                function() vim.cmd.tabprevious() end
              '';
              options.desc = "Previous tab";
            };
          };
    in
    helpers.keymaps.mkKeymaps { options.silent = true; } normal;
}
