{ lib, pkgs, ... }:
let
  inherit (lib.generators) mkLuaInline;
  inherit (lib.nvim.dag) entryAnywhere;
in
{
  programs.nvf.settings = {
    vim = {
      startPlugins = [
        "ts-error-translator-nvim"
        "nvim-ts-autotag"
      ];

      pluginRC = {
        ts-error-translator = entryAnywhere ''
          require("ts-error-translator").setup({ auto_override_publish_diagnostics = true })
        '';
        html-autotag = entryAnywhere ''
          require('nvim-ts-autotag').setup({})
        '';
      };

      treesitter = {
        enable = true;
        grammars = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
          tsx
          javascript
          typescript
          jsdoc
          vue
          html
        ];
      };

      lsp.servers = {
        vtsls = {
          enable = true;

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

        vue_ls = {
          enable = true;

          on_init = mkLuaInline ''
            function(client)
              client.handlers['tsserver/request'] = function(_, result, context)
                local ts_clients = vim.lsp.get_clients({ bufnr = context.bufnr, name = 'ts_ls' })
                local vtsls_clients = vim.lsp.get_clients({ bufnr = context.bufnr, name = 'vtsls' })
                local clients = {}

                vim.list_extend(clients, ts_clients)
                vim.list_extend(clients, vtsls_clients)

                if #clients == 0 then
                  vim.notify('Could not find `vtsls` or `ts_ls` lsp client, `vue_ls` would not work without it.', vim.log.levels.ERROR)
                  return
                end
                local ts_client = clients[1]

                local param = unpack(result)
                local id, command, payload = unpack(param)
                ts_client:exec_cmd({
                  title = 'vue_request_forward', -- You can give title anything as it's used to represent a command in the UI, `:h Client:exec_cmd`
                  command = 'typescript.tsserverRequest',
                  arguments = {
                    command,
                    payload,
                  },
                }, { bufnr = context.bufnr }, function(_, r)
                    local response = r and r.body
                    -- TODO: handle error or response nil here, e.g. logging
                    -- NOTE: Do NOT return if there's an error or no response, just return nil back to the vue_ls to prevent memory leak
                    local response_data = { { id, response } }

                    ---@diagnostic disable-next-line: param-type-mismatch
                    client:notify('tsserver/response', response_data)
                  end)
              end
            end
          '';

          cmd = [
            "${lib.getExe pkgs.vue-language-server}"
            "--stdio"
          ];
        };
      };

      formatter.conform-nvim = {
        enable = true;
        setupOpts = {
          formatters_by_ft = {
            typescript = [
              "eslint_d"
              "oxlint"
              (mkLuaInline ''stop_after_first = true'')
            ];
            typescriptreact = [
              "eslint_d"
              "oxlint"
              (mkLuaInline ''stop_after_first = true'')
            ];
            vue = [
              "eslint_d"
              "oxlint"
              (mkLuaInline ''stop_after_first = true'')
            ];
          };
          formatters = {
            eslint_d = {
              command = lib.getExe pkgs.eslint_d;
              cwd = mkLuaInline ''
                require("conform.util").root_file({
                  ".eslintrc",
                  ".eslintrc.js",
                  ".eslintrc.cjs",
                  ".eslintrc.yaml",
                  ".eslintrc.yml",
                  ".eslintrc.json",
                  "eslint.config.js",
                  "eslint.config.mjs",
                  "eslint.config.cjs",
                  "eslint.config.ts",
                  "eslint.config.mts",
                  "eslint.config.cts",
                })
              '';
              require_cwd = true;
            };
            oxlint.command = lib.getExe pkgs.oxlint;
          };
        };
      };

      diagnostics.nvim-lint = {
        enable = true;
        linters_by_ft = {
          typescript = [ "eslint_d" ];
          typescriptreact = [ "eslint_d" ];
          vue = [ "eslint_d" ];
        };
        linters = {
          eslint_d.cmd = lib.getExe pkgs.eslint_d;
        };
      };
    };
  };
}
