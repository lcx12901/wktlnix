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
            "<Leader>la" = {
              action.__raw = ''
                function() vim.lsp.buf.code_action() end
              '';
              options = {
                desc = "LSP code action";
              };
              cond = "textDocument/codeAction";
            };
            "<Leader>lA" = {
              action.__raw = ''
                function() vim.lsp.buf.code_action { context = { only = { "source" }, diagnostics = {} } } end
              '';
              options = {
                desc = "LSP code action";
              };
              cond = "textDocument/codeAction";
            };
            "<Leader>ll" = {
              action.__raw = ''
                function() vim.lsp.codelens.refresh() end
              '';
              options = {
                desc = "LSP CodeLens refresh";
              };
              cond = "textDocument/codeLens";
            };
            "<Leader>lL" = {
              action.__raw = ''
                function() vim.lsp.codelens.run() end
              '';
              options = {
                desc = "LSP CodeLens run";
              };
              cond = "textDocument/codeLens";
            };
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
            "<Leader>lR" = {
              action.__raw = ''
                function() vim.lsp.buf.references() end
              '';
              options = {
                desc = "Search references";
              };
              cond = "textDocument/references";
            };
            "<Leader>lr" = {
              action.__raw = ''
                function() vim.lsp.buf.rename() end
              '';
              options = {
                desc = "Rename current symbol";
              };
              cond = "textDocument/rename";
            };
            "<Leader>lh" = {
              action.__raw = ''
                function() vim.lsp.buf.signature_help() end
              '';
              options = {
                desc = "Signature help";
              };
              cond = "textDocument/signatureHelp";
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
            "<Leader>lG" = {
              action.__raw = ''
                function() vim.lsp.buf.workspace_symbol() end
              '';
              options = {
                desc = "Search workspace symbols";
              };
              cond = "workspace/symbol";
            };
          };
    in
    helpers.keymaps.mkKeymaps { options.silent = true; } normal;
}
