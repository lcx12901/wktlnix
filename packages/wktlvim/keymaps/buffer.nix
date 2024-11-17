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
            "<Leader>c" = {
              action.__raw = ''
                function() require("astrocore.buffer").close() end
              '';
              options.desc = "Close buffer";
            };
            "<Leader>C" = {
              action.__raw = ''
                function() require("astrocore.buffer").close(0, true) end
              '';
              options.desc = "Force close buffer";
            };
            "]b" = {
              action.__raw = ''
                function() require("astrocore.buffer").nav(vim.v.count1) end
              '';
              options.desc = "Next buffer";
            };
            "[b" = {
              action.__raw = ''
                function() require("astrocore.buffer").nav(-vim.v.count1) end
              '';
              options.desc = "Previous buffer";
            };
            ">b" = {
              action.__raw = ''
                function() require("astrocore.buffer").move(vim.v.count1) end
              '';
              options.desc = "Move buffer tab right";
            };
            "<b" = {
              action.__raw = ''
                function() require("astrocore.buffer").move(-vim.v.count1) end
              '';
              options.desc = "Move buffer tab left";
            };

            "<Leader>bc" = {
              action.__raw = ''
                function() require("astrocore.buffer").close_all(true) end
              '';
              options.desc = "Close all buffers except current";
            };
            "<Leader>bC" = {
              action.__raw = ''
                function() require("astrocore.buffer").close_all() end
              '';
              options.desc = "Close all buffers";
            };
            "<Leader>bl" = {
              action.__raw = ''
                function() require("astrocore.buffer").close_left() end
              '';
              options.desc = "Close all buffers to the left";
            };
            "<Leader>bp" = {
              action.__raw = ''
                function() require("astrocore.buffer").prev() end
              '';
              options.desc = "Previous buffer";
            };
            "<Leader>br" = {
              action.__raw = ''
                function() require("astrocore.buffer").close_right() end
              '';
              options.desc = "Close all buffers to the right";
            };

            "<Leader>bse" = {
              action.__raw = ''
                function() require("astrocore.buffer").sort "extension" end
              '';
              options.desc = "By extension";
            };
            "<Leader>bsr" = {
              action.__raw = ''
                function() require("astrocore.buffer").sort "unique_path" end
              '';
              options.desc = "By relative path";
            };
            "<Leader>bsp" = {
              action.__raw = ''
                function() require("astrocore.buffer").sort "full_path" end
              '';
              options.desc = "By full path";
            };
            "<Leader>bsi" = {
              action.__raw = ''
                function() require("astrocore.buffer").sort "bufnr" end
              '';
              options.desc = "By buffer number";
            };
            "<Leader>bsm" = {
              action.__raw = ''
                function() require("astrocore.buffer").sort "modified" end
              '';
              options.desc = "By modified time";
            };

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
