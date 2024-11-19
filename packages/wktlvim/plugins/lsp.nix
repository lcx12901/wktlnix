{
  config,
  lib,
  pkgs,
  namespace,
  self,
  ...
}:
let
  inherit (config) icons;
in
{
  extraConfigLuaPre = ''
    vim.fn.sign_define("DiagnosticSignError", { text = " ${icons.DiagnosticError}", texthl = "DiagnosticError", linehl = "", numhl = "" })
    vim.fn.sign_define("DiagnosticSignWarn", { text = " ${icons.DiagnosticWarn}", texthl = "DiagnosticWarn", linehl = "", numhl = "" })
    vim.fn.sign_define("DiagnosticSignHint", { text = " ${icons.DiagnosticHint}", texthl = "DiagnosticHint", linehl = "", numhl = "" })
    vim.fn.sign_define("DiagnosticSignInfo", { text = " ${icons.DiagnosticInfo}", texthl = "DiagnosticInfo", linehl = "", numhl = "" })

    vim.lsp.handlers["textDocument/hover"] = function(_, result, ctx, config)
      if not (result and result.contents) or vim.tbl_isempty(result.contents) then
        return
      end

      vim.lsp.with(vim.lsp.handlers.hover, {})(_, result, ctx, config)
    end

    local function preview_location_callback(_, result)
      if result == nil or vim.tbl_isempty(result) then
        vim.notify('No location found to preview')
        return nil
      end
    local buf, _ = vim.lsp.util.preview_location(result[1])
      if buf then
        local cur_buf = vim.api.nvim_get_current_buf()
        vim.bo[buf].filetype = vim.bo[cur_buf].filetype
      end
    end

    function peek_definition()
      local params = vim.lsp.util.make_position_params()
      return vim.lsp.buf_request(0, 'textDocument/definition', params, preview_location_callback)
    end

    local function peek_type_definition()
      local params = vim.lsp.util.make_position_params()
      return vim.lsp.buf_request(0, 'textDocument/typeDefinition', params, preview_location_callback)
    end

    require('lspconfig.ui.windows').default_options = {
      border = "rounded"
    }
  '';

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
          {
            action.__raw = "peek_definition";
            mode = "n";
            key = "<leader>lp";
            options = {
              desc = "Preview definition";
            };
          }
          {
            action.__raw = "peek_type_definition";
            mode = "n";
            key = "<leader>lP";
            options = {
              desc = "Preview type definition";
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

      servers = {
        nixd = {
          enable = false;
          filetypes = [ "nix" ];
          settings =
            let
              flake = ''(builtins.getFlake "${self}")'';
            in
            {
              nixpkgs = {
                expr = "import ${flake}.inputs.nixpkgs { }";
              };
              formatting = {
                command = [ "${lib.getExe pkgs.nixfmt-rfc-style}" ];
              };
              options = {
                nixos.expr = ''${flake}.nixosConfigurations.wktlnix.options'';
                nixvim.expr = ''${flake}.packages.${pkgs.system}.nvim.options'';
                home-manager.expr = ''${flake}.homeConfigurations."wktl@wktlnix".options'';
              };
            };
        };
        nil_ls = {
          # FIXME: when nixd works again
          # enable = !config.plugins.lsp.servers.nixd.enable;
          enable = true;
          filetypes = [ "nix" ];
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
          filetypes = [ "yaml" ];
        };

        taplo = {
          enable = true;
          filetypes = [ "toml" ];
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
