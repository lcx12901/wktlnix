{
  config,
  osConfig,
  lib,
  inputs,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.types) number;
  inherit (lib.${namespace}) mkBoolOpt mkOpt;

  cfg = config.${namespace}.programs.graphical.editors.vscode;

  persist = osConfig.${namespace}.system.persist.enable;

  extensions = inputs.nix-vscode-extensions.extensions.${pkgs.system};
in {
  options.${namespace}.programs.graphical.editors.vscode = {
    enable = mkBoolOpt false "Whether or not to enable vscode.";
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
        ];
      };

      extensions =
        (with extensions.vscode-marketplace; [
          ms-ceintl.vscode-language-pack-zh-hans
          vscode-icons-team.vscode-icons
          oderwat.indent-rainbow
          wix.vscode-import-cost
          streetsidesoftware.code-spell-checker
          usernamehw.errorlens
          editorconfig.editorconfig
          dbaeumer.vscode-eslint
          kamikillerto.vscode-colorize
          kamadorueda.alejandra
          jnoortheen.nix-ide
          eamodio.gitlens
          philsinatra.nested-comments
          mhutchie.git-graph
          mkhl.direnv
          nrwl.angular-console
          codium.codium
          gruntfuggly.todo-tree

          vue.volar
          antfu.unocss

          evils.uniapp-vscode
          uni-helper.uni-helper-vscode
          uni-helper.uni-app-schemas-vscode
          uni-helper.uni-highlight-vscode
          uni-helper.uni-ui-snippets-vscode
          uni-helper.uni-app-snippets-vscode
        ])
        ++ [
          (pkgs.catppuccin-vsc.override {
            accent = "lavender";
            boldKeywords = true;
            italicComments = true;
            italicKeywords = true;
            extraBordersEnabled = false;
            workbenchMode = "default";
            bracketMode = "rainbow";
            colorOverrides = {};
            customUIColors = {};
          })
        ];

      userSettings = {
        # Color theme
        "workbench.colorTheme" = "Catppuccin Mocha";
        "workbench.iconTheme" = "vscode-icons";

        # Font family
        "editor.fontFamily" = "MonaspiceAr Nerd Font, CaskaydiaCove Nerd Font,Consolas, monospace,Hack Nerd Font";
        "editor.codeLensFontFamily" = "MonaspiceNe Nerd Font, Liga SFMono Nerd Font, CaskaydiaCove Nerd Font,Consolas, 'Courier New', monospace,Hack Nerd Font";
        "editor.inlayHints.fontFamily" = "MonaspiceKr Nerd Font";
        "debug.console.fontFamily" = "Monaspace Krypton";
        "scm.inputFontFamily" = "Monaspace Radon";
        "notebook.output.fontFamily" = "Monapsace Radon";
        "chat.editor.fontFamily" = "Monaspace Argon";
        "markdown.preview.fontFamily" = "Monaspace Xenon; -apple-system, BlinkMacSystemFont, 'Segoe WPC', 'Segoe UI', system-ui, 'Ubuntu', 'Droid Sans', sans-serif";
        "terminal.integrated.fontFamily" = "JetBrainsMono Nerd Font Mono";

        # Git settings
        "git.allowForcePush" = true;
        "git.autofetch" = true;
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
        "editor.fontSize" = 16;
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
        "editor.cursorBlinking" = "smooth";
        "editor.cursorSmoothCaretAnimation" = "on";
        "editor.cursorSurroundingLinesStyle" = "all";
        "editor.tabSize" = 2;
        "editor.lineNumbers" = "relative";
        "editor.smoothScrolling" = true;
        "editor.suggestSelection" = "first";

        # Terminal
        "terminal.integrated.automationShell.linux" = "nix-shell";
        "accessibility.signals.terminalBell" = {
          "sound" = "off";
        };
        "terminal.integrated.defaultProfile.linux" = "fish";
        "terminal.integrated.gpuAcceleration" = "on";
        "terminal.integrated.smoothScrolling" = true;

        # Workbench
        "workbench.editor.tabCloseButton" = "left";
        "workbench.editor.tabActionLocation" = "left";
        "workbench.fontAliasing" = "antialiased";
        "workbench.list.smoothScrolling" = true;
        "workbench.panel.defaultLocation" = "right";
        "workbench.startupEditor" = "none";

        # Miscellaneous
        "breadcrumbs.enabled" = true;
        "explorer.confirmDelete" = false;
        "files.trimTrailingWhitespace" = true;
        "javascript.updateImportsOnFileMove.enabled" = "always";
        "security.workspace.trust.enabled" = false;
        "todo-tree.filtering.includeHiddenFiles" = true;
        "typescript.updateImportsOnFileMove.enabled" = "always";
        "vsicons.dontShowNewVersionMessage" = true;
        "window.menuBarVisibility" = "toggle";
        "window.nativeTabs" = true;
        "window.restoreWindows" = "all";
        "window.titleBarStyle" = "custom";
        "window.zoomLevel" = cfg.zoomLevel;

        # update
        "update.mode" = "none";
        "extensions.autoUpdate" = false;

        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nixd";
        "vue.server.hybridMode" = "auto";

        "npm.exclude" = [
          "**/.direnv/**"
          "**/.nx/**"
        ];

        "cSpell.words" = [
          "demi"
          "pinia"
          "vueuse"
          "tiptap"
        ];
      };
    };

    home.persistence = mkIf persist {
      "/persist/home/${config.${namespace}.user.name}" = {
        allowOther = true;
        directories = [".config/Code"];
      };
    };
  };
}
