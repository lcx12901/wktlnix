{
  inputs,
  config,
  lib,
  pkgs,
  system,
  self,
  ...
}:
{
  extraConfigLuaPre = ''
    require('lspconfig.ui.windows').default_options = {
      border = "rounded"
    }
  '';

  plugins = {
    # lsp-lines = {
    #   inherit (config.plugins.lsp) enable;
    # };
    # lsp-signature = {
    #   inherit (config.plugins.lsp) enable;
    # };

    lsp = {
      enable = true;
      inlayHints = true;

      keymaps = {
        silent = true;
        diagnostic = {
          # Navigate in diagnostics
          "<Leader>l[" = "goto_prev";
          "<Leader>l]" = "goto_next";
          "<Leader>lH" = "open_float";
        };

        extra = [
          {
            action.__raw = ''
              function()
                vim.lsp.buf.format({
                  async = true,
                  range = {
                    ["start"] = vim.api.nvim_buf_get_mark(0, "<"),
                    ["end"] = vim.api.nvim_buf_get_mark(0, ">"),
                  }
                })
              end
            '';
            mode = "v";
            key = "<Leader>lf";
            options = {
              desc = "Format selection";
            };
          }
          {
            action = "<CMD>PeekDefinition textDocument/definition<CR>";
            mode = "n";
            key = "<leader>lp";
            options = {
              desc = "Preview definition";
            };
          }
          {
            action = "<CMD>PeekDefinition textDocument/typeDefinition<CR>";
            mode = "n";
            key = "<leader>lP";
            options = {
              desc = "Preview type definition";
            };
          }
        ];

        lspBuf = {
          "<Leader>ld" = "definition";
          "<Leader>lD" = "references";
          "<Leader>lf" = "format";
          "<Leader>lh" = "hover";
          "<Leader>li" = "implementation";
          "<Leader>lr" = "rename";
          "<Leader>lt" = "type_definition";
        } // lib.optionalAttrs (!config.plugins.fzf-lua.enable) { "<leader>la" = "code_action"; };
      };

      servers = {
        bashls = {
          enable = true;
        };

        nixd = {
          enable = true;
          settings =
            let
              flake = ''(builtins.getFlake "${self}")'';
              system = ''''${builtins.currentSystem}'';
            in
            {
              nixpkgs = {
                expr = "import ${flake}.inputs.nixpkgs { }";
              };
              formatting = {
                command = [ "${lib.getExe pkgs.nixfmt-rfc-style}" ];
              };
              options = {
                nixvim.expr = ''${flake}.packages.${system}.nvim.options'';
              };
            };
        };
        nil_ls = {
          enable = false;
          settings = {
            formatting = {
              command = [ "${lib.getExe pkgs.nixfmt-rfc-style}" ];
            };
            nix = {
              flake = {
                autoArchive = true;
              };
            };
          };
        };

        lua_ls = {
          enable = true;
          filetypes = [ "lua" ];
        };

        eslint = {
          enable = false;
          filetypes = [
            "javascript"
            "javascriptreact"
            "typescript"
            "typescriptreact"
            "typescript.tsx"
            "vue"
            "astro"
            "svelte"
            "html"
            "json"
            "jsonc"
            "css"
            "scss"
          ];
          extraOptions = {
            rulesCustomizations = [
              {
                rule = "style/*";
                severity = "off";
                fixable = true;
              }
              {
                rule = "format/*";
                severity = "off";
                fixable = true;
              }
              {
                rule = "*-indent";
                severity = "off";
                fixable = true;
              }
              {
                rule = "*-spacing";
                severity = "off";
                fixable = true;
              }
              {
                rule = "*-spaces";
                severity = "off";
                fixable = true;
              }
              {
                rule = "*-order";
                severity = "off";
                fixable = true;
              }
              {
                rule = "*-dangle";
                severity = "off";
                fixable = true;
              }
              {
                rule = "*-newline";
                severity = "off";
                fixable = true;
              }
              {
                rule = "*quotes";
                severity = "off";
                fixable = true;
              }
              {
                rule = "*semi";
                severity = "off";
                fixable = true;
              }
            ];
          };
        };

        ts_ls = {
          enable = true;
          # extraOptions = {
          #   init_options = {
          #     plugins = [
          #       {
          #         name = "@vue/typescript-plugin";
          #         location = "${
          #           lib.getBin pkgs.${namespace}.vue-language-server
          #         }/lib/node_modules/@vue/language-server";
          #         languages = [ "vue" ];
          #       }
          #     ];
          #   };
          # };
        };

        volar = {
          enable = true;
          package = inputs.wktlpkgs.packages.${system}.vue-language-server;
          extraOptions = {
            init_options = {
              vue = {
                hybridMode = true;
              };
              typescript = {
                tsdk = "${pkgs.typescript}/lib/node_modules/typescript/lib";
              };
            };
          };
        };

        unocss = {
          enable = true;
          package = inputs.wktlpkgs.packages.${system}.unocss-language-server;
        };

        jsonls = {
          enable = true;
          filetypes = [
            "json"
            "jsonc"
          ];
        };

        yamlls = {
          enable = true;
          filetypes = [ "yaml" ];
        };

        taplo = {
          enable = true;
          filetypes = [ "toml" ];
        };

        marksman = {
          enable = true;
        };
      };
    };

    which-key.settings.spec = [
      {
        __unkeyed = "<leader>l";
        group = "LSP";
        icon = " ";
      }
      {
        __unkeyed = "<leader>la";
        desc = "Code Action";
      }
      {
        __unkeyed = "<leader>ld";
        desc = "Definition";
      }
      {
        __unkeyed = "<leader>lD";
        desc = "References";
      }
      {
        __unkeyed = "<leader>lf";
        desc = "Format";
      }
      {
        __unkeyed = "<leader>l[";
        desc = "Prev";
      }
      {
        __unkeyed = "<leader>l]";
        desc = "Next";
      }
      {
        __unkeyed = "<leader>lt";
        desc = "Type Definition";
      }
      {
        __unkeyed = "<leader>li";
        desc = "Implementation";
      }
      {
        __unkeyed = "<leader>lh";
        desc = "Lsp Hover";
      }
      {
        __unkeyed = "<leader>lH";
        desc = "Diagnostic Hover";
      }
      {
        __unkeyed = "<leader>lr";
        desc = "Rename";
      }
    ];
  };
}
