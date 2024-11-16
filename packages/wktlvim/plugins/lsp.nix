{
  config,
  lib,
  pkgs,
  namespace,
  self,
  ...
}: let
  inherit (config) icons;
in {
  plugins = {
    lspkind.enable = true;
    lsp-lines.enable = true;
    lsp-signature.enable = true;

    lsp = {
      enable = true;

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
        ];

        lspBuf = {
          "<Leader>la" = "code_action";
          "<Leader>ld" = "definition";
          "<Leader>lD" = "references";
          "<Leader>lf" = "format";
          "<Leader>lh" = "hover";
          "<Leader>li" = "implementation";
          "<Leader>lr" = "rename";
          "<Leader>lt" = "type_definition";
        };
      };

      postConfig = ''
        vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })

        vim.diagnostic.config({
          virtual_text = false,
          signs = true,
          underline = true,
          update_in_insert = true,
          severity_sort = false,
        })

        local signs = {
          Error = "${icons.DiagnosticError}",
          Warn = "${icons.DiagnosticWarn}",
          Info = "${icons.DiagnosticInfo}",
          Hint = "${icons.DiagnosticHint}",
        }

        for type, icon in pairs(signs) do
          local hl = "DiagnosticSign" .. type
          vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
        end
      '';

      servers = {
        nixd = {
          enable = true;
          filetypes = ["nix"];
          settings = let
            flake = ''(builtins.getFlake "${self}")'';
          in {
            nixpkgs = {
              expr = "import ${flake}.inputs.nixpkgs { }";
            };
            formatting = {
              command = ["${lib.getExe pkgs.nixfmt-rfc-style}"];
            };
            options = {
              nixos.expr = ''${flake}.nixosConfigurations.wktlnix.options'';
              nixvim.expr = ''${flake}.packages.${pkgs.system}.nvim.options'';
              home-manager.expr = ''${flake}.homeConfigurations."wktl@wktlnix".options'';
            };
          };
        };

        lua_ls = {
          enable = true;
          filetypes = ["lua"];
        };

        eslint = {
          enable = true;
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
            ];
          };
        };

        ts_ls = {
          enable = true;
        };

        volar = {
          enable = true;
          extraOptions = {
            init_options = {
              vue = {
                hybridMode = false;
              };
              typescript = {
                tsdk = "${pkgs.typescript}/lib/node_modules/typescript/lib";
              };
            };
          };
        };

        unocss = {
          enable = true;
          package = pkgs.${namespace}.unocss-language-server;
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
          filetypes = ["yaml"];
        };

        taplo = {
          enable = true;
          filetypes = ["toml"];
        };
      };
    };
  };
}
