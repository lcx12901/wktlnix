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
        typescript-language-server
        vue-language-server
        tailwindcss-language-server
      ];

      userSettings = {
        theme = "Catppuccin Macchiato";
        icon_theme = "Catppuccin Macchiato";

        font_family = "Maple Mono NF CN";
        buffer_font_family = "Maple Mono NF CN";
        ui_font_family = "Maple Mono NF CN";

        buffer_font_size = 16;
        ui_font_size = 17;

        terminal = {
          font_family = "Maple Mono NF CN";
          font_size = 15;
        };

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

        ## tell zed to use direnv and direnv can use a flake.nix enviroment.
        load_direnv = "shell_hook";

        features = {
          edit_prediction_provider = "copilot";
        };

        languages =
          let
            ts = {
              language_servers = [
                "typescript-language-server"
                "!vtsls"
                "..."
              ];
              prettier = {
                allowed = false;
              };
              formatter = {
                "code_actions" = {
                  "source.fixAll.eslint" = true;
                };
              };
            };
          in
          {
            "Vue.js" = {
              inherit (ts) prettier formatter;
            };
            TypeScript = {
              inherit (ts) language_servers prettier formatter;
            };
            TSX = {
              inherit (ts) language_servers prettier formatter;
            };
          };

        lsp = {
          nil = {
            initialization_options = {
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
        };
      };

      userKeymaps = [
        {
          context = "vim_mode == normal || vim_mode == visual";
          bindings = {
            "space l f" = "editor::Format";
            "s" = "vim::PushSneak";
            "shift-s" = "vim::PushSneakBackward";
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
