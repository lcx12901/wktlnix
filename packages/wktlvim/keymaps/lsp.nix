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
            "<Leader>uL" = {
              action.__raw = ''
                function() require("astrolsp.toggles").codelens() end
              '';
              options = {
                desc = "Toggle CodeLens";
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
            "<Leader>uY" = {
              action.__raw = ''
                function() require("astrolsp.toggles").buffer_semantic_tokens() end
              '';
              options = {
                desc = "Toggle LSP semantic highlight (buffer)";
              };
              cond.__raw = ''
                function(client)
                  return client.supports_method "textDocument/semanticTokens/full" and vim.lsp.semantic_tokens
                end
              '';
            };
          };
    in
    helpers.keymaps.mkKeymaps { options.silent = true; } normal;
}
