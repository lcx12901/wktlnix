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
        lua-language-server
        vscode-langservers-extracted
        stylua
      ];

      userSettings = {
        icon_theme = "Catppuccin Macchiato";

        buffer_font_size = lib.mkForce 20;
        ui_font_size = lib.mkForce 20;
        terminal.font_size = lib.mkForce 18;
        buffer_font_features = {
          "calt" = true;
          "zero" = true;
          "cv03" = true;
          "ss08" = true;
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

        languages = {
          Lua = {
            format_on_save = "on";
            formatter = {
              external = {
                command = "stylua";
                arguments = [
                  "--syntax=Lua54"
                  "--respect-ignores"
                  "--stdin-filepath"
                  "{buffer_path}"
                  "-"
                ];
              };
            };
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
        nix
        lua
        git-firefly
        # theme
        catppuccin-icons
      ];
    };
  };
}
