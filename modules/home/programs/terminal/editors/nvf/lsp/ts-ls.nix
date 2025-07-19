{
  inputs,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.generators) mkLuaInline;
  inherit (inputs.nvf.lib.nvim.dag) entryAnywhere;
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

      lsp.servers.ts_ls = {
        enable = true;

        capabilities = mkLuaInline "capabilities";
        on_attach = mkLuaInline "default_on_attach";

        filetypes = [
          "typescript"
          "javascript"
          "javascriptreact"
          "typescriptreact"
          "vue"
        ];

        cmd = [
          "${lib.getExe pkgs.typescript-language-server}"
          "--stdio"
        ];

        init_options = {
          plugins = [
            {
              name = "@vue/typescript-plugin";
              location = "${lib.getBin pkgs.vue-language-server}/lib/node_modules/@vue/language-server";
              languages = [ "vue" ];
            }
          ];
        };
        settings = {
          /*
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
              autoUseWorkspaceTsdk = true;
              enableMoveToFileCodeAction = true;

              globalPlugins = [
                {
                  name = "@vue/typescript-plugin";
                  location = "${
                    lib.getBin pkgs.${namespace}.vue-language-server
                  }/lib/node_modules/@vue/language-server";
                  languages = [ "vue" ];
                  configNamespace = "typescript";
                  enableForWorkspaceTypeScriptVersions = true;
                }
              ];
            };
          */
        };
      };
    };
  };
}
