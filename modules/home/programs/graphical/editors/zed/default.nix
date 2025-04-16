{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.programs.graphical.editors.zed;
in
{
  options.${namespace}.programs.graphical.editors.zed = {
    enable = lib.mkEnableOption "Whether or not to enable zed.";
  };

  config = lib.mkIf cfg.enable {
    programs.zed-editor = {
      enable = true;

      extraPackages = with pkgs; [
        nil
        vscode-langservers-extracted
        vtsls
        vue-language-server
        jsonnet-language-server

        eslint_d
      ];

      userSettings = {
        vim_mode = true;
        vim = {
          enable_vim_sneak = true;
        };

        theme = "Catppuccin Macchiato";
        icon_theme = "Catppuccin Macchiato";

        font_family = "Maple Mono NF CN";
        buffer_font_family = "Maple Mono NF CN";
        ui_font_family = "Maple Mono NF CN";

        relative_line_numbers = true;

        indent_guides = {
          enabled = true;
          coloring = "indent_aware";
        };

        inlay_hints = {
          enabled = true;
        };

        auto_install_extensions = {
          html = false;
        };

        auto_update = false;

        prettier = {
          allowed = false;
        };

        languages = {
          "Vue.js" = {
            prettier = {
              allowed = false;
            };
            code_actions_on_format = {
              "source.fixAll.eslint" = true;
            };
          };
          TypeScript = {
            prettier = {
              allowed = false;
            };
            code_actions_on_format = {
              "source.fixAll.eslint" = true;
            };
          };
          Nix = {
            language_servers = [
              "nil"
              "!nixd"
            ];
          };
        };

        lsp = {
          nil = {
            initialization_options = {
              formatting = {
                command = [ "${lib.getExe pkgs.nixfmt-rfc-style}" ];
              };
            };
          };
          vue = {
            initialization_options = {
              typescript = {
                tsdk = "${pkgs.typescript}/lib/node_modules/typescript/lib";
              };
            };
          };
        };
      };

      userKeymaps = [
        {
          context = "Editor && (vim_mode == normal || vim_mode == visual)";
          bindings = {
            "space l f" = "editor::Format";
          };
        }
      ];
    };

    programs.zed-editor-extensions = {
      enable = true;
      packages = with pkgs.zed-extensions; [
        # lsp
        nix
        vue
        unocss

        git-firefly

        # theme
        catppuccin
        catppuccin-icons
      ];
    };
  };
}
