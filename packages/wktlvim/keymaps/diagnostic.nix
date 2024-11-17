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
            "gl" = {
              action.__raw = ''
                function() vim.diagnostic.open_float() end
              '';
              options.desc = "Hover diagnostics";
            };
            "[d" = {
              action = "vim.diagnostic.goto_prev()";
              options.desc = "Previous diagnostic";
            };
            "]d" = {
              action = "vim.diagnostic.goto_next()";
              options.desc = "Next diagnostic";
            };
            "[e" = {
              action = "vim.diagnostic.goto_prev({severity = vim.diagnostic.severity.ERROR})";
              options.desc = "Previous error";
            };
            "]e" = {
              action = "vim.diagnostic.goto_next({severity = vim.diagnostic.severity.ERROR})";
              options.desc = "Next error";
            };
            "[w" = {
              action = "vim.diagnostic.goto_prev({severity = vim.diagnostic.severity.WARNING})";
              options.desc = "Previous warning";
            };
            "]w" = {
              action = "vim.diagnostic.goto_next({severity = vim.diagnostic.severity.WARNING})";
              options.desc = "Next warning";
            };
          };
    in
    helpers.keymaps.mkKeymaps { options.silent = true; } normal;
}
