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
        unocss-language-server
      ];

      userSettings = cfg.userSettings // {
        auto_update = false;
        vim_mode = true;

        auto_install_extensions = {
          html = false;
        };

        edit_predictions = {
          provider = "copilot";
        };

        icon_theme = "Catppuccin Macchiato";
        theme_overrides = {
          "Base16 Catppuccin Macchiato" = {
            syntax = {
              comment = {
                font_style = "italic";
              };
              "comment.doc" = {
                font_style = "italic";
              };
              keyword = {
                font_style = "italic";
              };
              "keyword.control" = {
                font_style = "italic";
              };
            };
          };
        };
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
            format_on_save = "on";
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
          CSS = {
            language_servers = [
              "vscode-css-language-server"
              "!tailwindcss-intellisense-css"
              "..."
            ];
          };
          TypeScript = {
            format_on_save = "on";
            formatter = {
              code_actions = {
                "source.fixAll.eslint" = true;
                "source.organizeImports" = true;
              };
            };
          };
          TSX = {
            format_on_save = "on";
            formatter = {
              code_actions = {
                "source.fixAll.eslint" = true;
                "source.organizeImports" = true;
              };
            };
          };
          "Vue.js" = {
            format_on_save = "on";
            formatter = {
              code_actions = {
                "source.fixAll.eslint" = true;
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
          unocss-language-server = {
            binary = {
              path = lib.getExe pkgs.unocss-language-server;
              arguments = [ "--stdio" ];
            };
          };
          eslint = {
            binary = {
              path = lib.getExe' pkgs.vscode-langservers-extracted "vscode-eslint-language-server";
              arguments = [ "--stdio" ];
            };
          };
          json-language-server = {
            binary = {
              path = lib.getExe' pkgs.vscode-langservers-extracted "vscode-json-language-server";
              arguments = [ "--stdio" ];
            };
          };
          vtsls = {
            binary = {
              path = lib.getExe pkgs.vtsls;
              arguments = [ "--stdio" ];
            };
          };
          vscode-css-language-server = {
            binary = {
              path = lib.getExe' pkgs.vscode-langservers-extracted "vscode-css-language-server";
              arguments = [ "--stdio" ];
            };
          };
          tailwindcss-language-server = {
            binary = {
              path = lib.getExe pkgs.tailwindcss-language-server;
              arguments = [ "--stdio" ];
            };
            settings = {
              includeLanguages = { };
            };
          };
          package-version-server = {
            binary = {
              path = lib.getExe pkgs.package-version-server;
            };
          };
        };
      };

      userKeymaps = [
        # 通用操作 (Normal + Visual)
        {
          context = "vim_mode == normal || vim_mode == visual";
          bindings = {
            "space q" = "zed::Quit";
            "space Q" = "workspace::CloseWindow";
            "-" = "pane::SplitDown";
            "|" = "pane::SplitRight";
            "space w d" = "pane::CloseActiveItem";
            "s" = "vim::PushSneak";
            "shift-s" = "vim::PushSneakBackward";
          };
        }
        # 格式化
        {
          context = "vim_mode == normal || vim_mode == visual";
          bindings = {
            "space l f" = "editor::Format";
            "space c f" = "editor::Format";
          };
        }
        # 查找 (EmptyPane/SharedScreen + Workspace)
        {
          context = "EmptyPane || SharedScreen";
          bindings = {
            "space space" = "file_finder::Toggle";
          };
        }
        {
          context = "Workspace";
          bindings = {
            "space f f" = "file_finder::Toggle";
            "space f w" = "project_search::ToggleFocus";
            "space f W" = "project_search::ToggleFocus";
            "space f b" = "tab_switcher::Toggle";
            "space f o" = "projects::OpenRecent";
            "space f k" = "command_palette::Toggle";
            "space f m" = "command_palette::Toggle";
            "space f s" = "workspace::Save";
            "space f S" = "workspace::SaveAll";
          };
        }
        # LSP 操作
        {
          context = "vim_mode == normal";
          bindings = {
            "space c a" = "editor::ToggleCodeActions";
            "space c r" = "editor::Rename";
            "space c d" = "diagnostics::Deploy";
          };
        }
        # Tab 切换
        {
          context = "Pane";
          bindings = {
            "alt-1" = [
              "pane::ActivateItem"
              0
            ];
            "alt-2" = [
              "pane::ActivateItem"
              1
            ];
            "alt-3" = [
              "pane::ActivateItem"
              2
            ];
            "alt-4" = [
              "pane::ActivateItem"
              3
            ];
            "alt-5" = [
              "pane::ActivateItem"
              4
            ];
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
