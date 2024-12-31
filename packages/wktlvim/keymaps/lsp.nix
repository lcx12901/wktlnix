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
            "gD" = {
              action.__raw = ''
                function() vim.lsp.buf.declaration() end
              '';
              options = {
                desc = "Declaration of current symbol";
              };
              cond = "textDocument/declaration";
            };
            "gd" = {
              action.__raw = ''
                function() vim.lsp.buf.definition() end
              '';
              options = {
                desc = "Show the definition of current symbol";
              };
              cond = "textDocument/definition";
            };
            "gI" = {
              action.__raw = ''
                function() vim.lsp.buf.implementation() end
              '';
              options = {
                desc = "Implementation of current symbol";
              };
              cond = "textDocument/implementation";
            };
            "gK" = {
              action.__raw = ''
                function() vim.lsp.buf.signature_help() end
              '';
              options = {
                desc = "Signature help";
              };
              cond = "textDocument/signatureHelp";
            };
            "gy" = {
              action.__raw = ''
                function() vim.lsp.buf.type_definition() end
              '';
              options = {
                desc = "Definition of current type";
              };
              cond = "textDocument/typeDefinition";
            };
          };
    in
    helpers.keymaps.mkKeymaps { options.silent = true; } normal;
}
