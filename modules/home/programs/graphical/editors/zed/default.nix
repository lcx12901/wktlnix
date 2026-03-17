{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption types;
  inherit (lib.wktlnix) mkOpt;

  cfg = config.wktlnix.programs.graphical.editors.zed;
in
{
  options.wktlnix.programs.graphical.editors.zed = {
    enable = mkEnableOption "zed";
    userSettings =
      mkOpt types.attrs { }
        "user settings for zed editor, see https://zed.dev/docs/settings for more details.";
  };

  config = mkIf cfg.enable {
    programs.zed-editor = {
      enable = true;

      extraPackages = with pkgs; [
        nixd
        nixfmt
        lua-language-server
        stylua
      ];

      userSettings = cfg.userSettings // {
        auto_update = false;

        auto_install_extensions = {
          html = false;
        };

        edit_predictions = {
          provider = "copilot";
        };

        icon_theme = "Catppuccin Macchiato";
        buffer_font_features = {
          "calt" = true;
          "zero" = true;
          "cv03" = true;
          "ss08" = true;
        };
        soft_wrap = "editor_width";
        relative_line_numbers = "enabled";
        indent_guides = {
          enabled = true;
          coloring = "indent_aware";
        };

        ## tell zed to use direnv and direnv can use a flake.nix enviroment.
        load_direnv = "shell_hook";

        node = {
          path = lib.getExe pkgs.nodejs;
          npm_path = lib.getExe' pkgs.nodejs "npm";
        };

        prettier = {
          allowed = false;
        };
        inlay_hints = {
          enabled = true;
        };
        languages = {
          Nix = {
            language_servers = [
              "nixd"
              "!nil"
            ];
          };
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
          nixd = {
            initialization_options = {
              formatting = {
                command = [ "nixfmt" ];
              };
            };
          };
          eslint = {
            binary = {
              path = "${lib.getExe' pkgs.vscode-langservers-extracted "vscode-eslint-language-server"}";
              arguments = [ "--stdio" ];
            };
          };
          json-language-server = {
            binary = {
              path = "${lib.getExe' pkgs.vscode-langservers-extracted "vscode-json-language-server"}";
              arguments = [ "--stdio" ];
            };
          };
          vtsls = {
            binary = {
              path = lib.getExe pkgs.vtsls;
              arguments = [ "--stdio" ];
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
        vue
        unocss
        git-firefly
        # theme
        catppuccin-icons
      ];
    };
  };
}
