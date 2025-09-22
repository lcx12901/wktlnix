{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.wktlnix.programs.graphical.editors.zed;
in
{
  options.wktlnix.programs.graphical.editors.zed = {
    enable = mkEnableOption "Whether or not to enable zed.";
  };

  config = mkIf cfg.enable {
    programs.zed-editor = {
      enable = true;

      extraPackages = with pkgs; [
        nil
        vscode-langservers-extracted
        vtsls
        vue-language-server
        tailwindcss-language-server
      ];

      userSettings = {
        icon_theme = "Catppuccin Macchiato";

        buffer_font_size = lib.mkForce 16;
        ui_font_size = lib.mkForce 17;

        terminal = {
          font_size = lib.mkForce 15;
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
            formatter = {
              "code_actions" = {
                "source.fixAll.eslint" = true;
              };
            };
          in
          {
            "Vue.js" = {
              inherit formatter;
              language_servers = [
                "vtsls"
                "..."
              ];
            };
            TypeScript = {
              inherit formatter;
            };
            TSX = {
              inherit formatter;
            };
          };

        lsp = {
          nil = {
            initialization_options = {
              formatting = {
                command = [ "${lib.getExe pkgs.nixfmt}" ];
              };
              nix = {
                flake = {
                  autoArchive = true;
                };
              };
            };
          };
          vue-language-server = {
            initialization_options = {
              vue = {
                hybridMode = true;
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
        html
        nix
        vue
        unocss

        git-firefly

        # theme
        catppuccin-icons
      ];
    };
  };
}
