{ lib, pkgs, ... }:
let
  inherit (lib.generators) mkLuaInline;
  inherit (lib.nvim.dag) entryAnywhere;
in
{
  programs.nvf.settings = {
    vim = {
      startPlugins = [ "ts-error-translator-nvim" ];

      pluginRC = {
        ts-error-translator = entryAnywhere ''
          require("ts-error-translator").setup({ auto_override_publish_diagnostics = true })
        '';
      };

      treesitter = {
        enable = true;
        grammars = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
          tsx
          javascript
          typescript
          jsdoc
        ];
      };

      lsp.servers.vtsls = {
        enable = true;

        capabilities = mkLuaInline "capabilities";
        on_attach = mkLuaInline ''
          function(client)
            if vim.bo.filetype == 'vue' then
              client.server_capabilities.semanticTokensProvider.full = false
            else
              client.server_capabilities.semanticTokensProvider.full = true
            end
          end
        '';

        filetypes = [
          "typescript"
          "javascript"
          "javascriptreact"
          "typescriptreact"
          "vue"
        ];

        cmd = [
          "${lib.getExe pkgs.vtsls}"
          "--stdio"
        ];

        settings = {
          typescript = {
            updateImportsOnFileMove.enabled = "always";
            inlayHints = {
              parameterNames.enabled = "all";
              parameterTypes.enabled = true;
              variableTypes.enabled = true;
              propertyDeclarationTypes.enabled = true;
              functionLikeReturnTypes.enabled = true;
              enumMemberValues.enabled = true;
            };
            tsserver.maxTsServerMemory = 8192;
          };
          javascript = {
            updateImportsOnFileMove.enabled = "always";
            inlayHints = {
              parameterNames = "literals";
              parameterTypes.enabled = true;
              variableTypes.enabled = true;
              propertyDeclarationTypes.enabled = true;
              functionLikeReturnTypes.enabled = true;
              enumMemberValues.enabled = true;
            };
          };
          vtsls = {
            enableMoveToFileCodeAction = true;
            experimental.completion.enableServerSideFuzzyMatch = true;

            tsserver = {
              globalPlugins = [
                {
                  name = "@vue/typescript-plugin";
                  location = "${lib.getBin pkgs.vue-language-server}/lib/language-tools/packages/language-server";
                  languages = [ "vue" ];
                  configNamespace = "typescript";
                }
              ];
            };
          };
        };
      };
    };
  };
}
