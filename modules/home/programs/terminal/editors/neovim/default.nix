{
  osConfig,
  config,
  inputs,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.${namespace}) mkBoolOpt;
  inherit (inputs) home-manager;

  cfg = config.${namespace}.programs.terminal.editors.neovim;

  persist = osConfig.${namespace}.system.persist.enable;

  shellAliases = {
    v = "nvim";
    vdiff = "nvim -d";
  };
in {
  options.${namespace}.programs.terminal.editors.neovim = {
    enable = mkEnableOption "neovim";
    default = mkBoolOpt true "Whether to set Neovim as the session EDITOR";
  };

  config = mkIf cfg.enable {
    programs.neovim = {
      enable = true;

      defaultEditor = true;
      viAlias = true;
      vimAlias = true;

      extraWrapperArgs = with pkgs; [
        "--suffix"
        "LIBRARY_PATH"
        ":"
        "${lib.makeLibraryPath [stdenv.cc.cc zlib]}"

        "--suffix"
        "PKG_CONFIG_PATH"
        ":"
        "${lib.makeSearchPathOutput "dev" "lib/pkgconfig" [stdenv.cc.cc zlib]}"
      ];

      plugins = with pkgs.vimPlugins; [
        telescope-fzf-native-nvim
        nvim-treesitter.withAllGrammars
      ];
    };

    home = {
      shellAliases = shellAliases;

      persistence = mkIf persist {
        "/persist/home/${config.${namespace}.user.name}" = {
          allowOther = true;
          directories = [".local/share/nvim" ".cache/nvim"];
        };
      };

      activation.installAstroNvim = home-manager.lib.hm.dag.entryAfter ["writeBoundary"] ''
        ${pkgs.rsync}/bin/rsync -avz --chmod=D2755,F744 ${./src}/ ${config.xdg.configHome}/nvim/
      '';

      packages = with pkgs; (
        [
          neovide
        ]
        ++
        # -*- Data & Configuration Languages -*-#
        [
          #-- nix
          nil
          statix # Lints and suggestions for the nix programming language
          deadnix # Find and remove unused code in .nix source files
          alejandra # Nix Code Formatter
        ]
        ++
        #-*- General Purpose Languages -*-#
        [
          #-- c/c++
          cmake
          cmake-language-server
          gnumake
          checkmake
          # c/c++ compiler, required by nvim-treesitter!
          gcc
          gdb
          # c/c++ tools with clang-tools, the unwrapped version won't
          # add alias like `cc` and `c++`, so that it won't conflict with gcc
          clang-tools
          lldb

          #-- zig
          zls

          #-- lua
          stylua
          lua-language-server

          #-- bash
          nodePackages.bash-language-server
          shellcheck
          shfmt

          #-- frontend
          vue-language-server
          typescript
          nodePackages.typescript-language-server
          # HTML/CSS/JSON/ESLint language servers extracted from vscode
          nodePackages.vscode-langservers-extracted
          emmet-ls
        ]
        ++ [
          fzf
          gdu # disk usage analyzer, required by AstroNvim
          (ripgrep.override {withPCRE2 = true;}) # recursively searches directories for a regex pattern
        ]
      );
    };
  };
}
