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
        tailwindcss-language-server

        eslint_d
      ];

      userSettings = {
        vim_mode = true;
        vim = {
          enable_vim_sneak = true;
        };
        theme = "Catppuccin Macchiato";
        icon_theme = "Catppuccin Macchiato";

        auto_install_extensions = {
          html = false;
        };

        auto_update = false;

        prettier = {
          allowed = false;
        };

        languages = {
          "Vue.js" = {
            formatter = "eslint";
            code_actions_on_format = {
              "source.fixAll.eslint" = true;
            };
          };
          TypeScript = {
            formatter = "eslint";
            code_actions_on_format = {
              "source.fixAll.eslint" = true;
            };
          };
        };
      };
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
