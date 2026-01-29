{
  config,
  osConfig,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (lib.wktlnix) mkOpt;

  cfg = config.wktlnix.programs.graphical.editors.vscode;

  persist = osConfig.wktlnix.system.persist.enable;
in
{
  options.wktlnix.programs.graphical.editors.vscode = with lib.types; {
    enable = mkEnableOption "Whether or not to enable vscode.";
    zoomLevel = mkOpt number 0 "set vscode window zoom level.";
  };

  config = mkIf cfg.enable {
    home.file = {
      ".vscode/argv.json" = {
        text = builtins.toJSON {
          "enable-crash-reporter" = true;
          "crash-reporter-id" = "e3a135d0-fdb1-4b4d-8a97-ee4dbd34a645";
          "locale" = "zh-cn";
          "password-store" = "basic";
        };
      };
    };

    programs.vscode = {
      enable = true;

      package = pkgs.vscode.override {
        commandLineArgs = [
          "--ozone-platform-hint=auto"
          "--ozone-platform=wayland"
          "--gtk-version=4"
          "--enable-wayland-ime"
          "--wayland-text-input-version=3"
        ];
      };

      profiles =
        let
          commonExtensions = with pkgs.nix-vscode-extensions.vscode-marketplace-release; [
            ms-ceintl.vscode-language-pack-zh-hans
            christian-kohler.path-intellisense
            streetsidesoftware.code-spell-checker
            usernamehw.errorlens
            eamodio.gitlens
            gruntfuggly.todo-tree
            formulahendry.auto-close-tag
            formulahendry.auto-rename-tag
            shardulm94.trailing-spaces
            dbaeumer.vscode-eslint
            vue.volar
            github.copilot
            github.copilot-chat
          ];

          commonSettings = {
            "workbench.iconTheme" = "vscode-icons";

            # Git settings
            "git.allowForcePush" = true;
            "git.autofetch" = true;
            "git.blame.editorDecoration.enabled" = true;
            "git.confirmSync" = false;
            "git.enableSmartCommit" = true;
            "git.openRepositoryInParentFolders" = "always";
            "gitlens.gitCommands.skipConfirmations" = [
              "fetch:command"
              "stash-push:command"
              "switch:command"
              "branch-create:command"
            ];

            # Editor
            "editor.bracketPairColorization.enabled" = true;
            "editor.fontLigatures" = true;
            "editor.fontSize" = lib.mkForce 16;
            "editor.formatOnPaste" = true;
            "editor.formatOnSave" = true;
            "editor.formatOnType" = false;
            "editor.guides.bracketPairs" = true;
            "editor.guides.indentation" = true;
            "editor.inlineSuggest.enabled" = true;
            "editor.minimap.enabled" = false;
            "editor.minimap.renderCharacters" = false;
            "editor.overviewRulerBorder" = false;
            "editor.renderLineHighlight" = "all";
            "editor.smoothScrolling" = true;
            "editor.suggestSelection" = "first";

            # Terminal
            "terminal.integrated.cursorBlinking" = true;
            "terminal.integrated.defaultProfile.linux" = "fish";
            "terminal.integrated.enableVisualBell" = false;
            "terminal.integrated.gpuAcceleration" = "on";

            # Workbench
            "workbench.list.smoothScrolling" = true;
            "workbench.startupEditor" = "none";
            "workbench.editor.tabActionLocation" = "left";

            # Miscellaneous
            "breadcrumbs.enabled" = true;
            "explorer.confirmDelete" = false;
            "files.trimTrailingWhitespace" = true;
            "javascript.updateImportsOnFileMove.enabled" = "always";
            "security.workspace.trust.enabled" = false;
            "todo-tree.filtering.includeHiddenFiles" = true;
            "typescript.updateImportsOnFileMove.enabled" = "always";
            "window.menuBarVisibility" = "toggle";
            "window.restoreWindows" = "all";
            "window.titleBarStyle" = "custom";

            "github.copilot.nextEditSuggestions.enabled" = true;

            "eslint.format.enable" = true;
            "eslint.useFlatConfig" = true;
            "typescript.tsserver.maxTsServerMemory" = 16384;
            "css.lint.unknownAtRules" = "ignore";
            "scss.lint.unknownAtRules" = "ignore";
            "less.lint.unknownAtRules" = "ignore";
            "[vue]" = {
              "editor.defaultFormatter" = "dbaeumer.vscode-eslint";
            };
            "[javascript]" = {
              "editor.defaultFormatter" = "dbaeumer.vscode-eslint";
            };
            "[typescript]" = {
              "editor.defaultFormatter" = "dbaeumer.vscode-eslint";
            };
          };
        in
        {
          default = {
            extensions = commonExtensions;
            enableUpdateCheck = false;
            enableExtensionUpdateCheck = false;
            userSettings = commonSettings;
          };
        };
    };

    home.persistence = mkIf persist {
      "/persist" = {
        directories = [ ".config/Code" ];
      };
    };
  };
}
