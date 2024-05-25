{config, lib, namespace, ...}: let
  inherit (lib) types mkIf mapAttrs;
  inherit (lib.${namespace}) mkBoolOpt mkOpt enabled;

  cfg = config.${namespace}.system.fonts;
in {
  options.${namespace}.system.fonts = with types; {
    enable = mkBoolOpt false "Whether or not to manage fonts.";
    default = mkOpt str "MonaspiceNe Nerd Font" "Default font name";
  };

  config = mkIf cfg.enable {
    environment.variables = {
      # Enable icons in tooling since we have nerdfonts.
      LOG_ICONS = "true";
    };

    fonts = {
      fontDir = {
        enable = true;
        decompressFonts = true;
      };

      packages = with pkgs; [
        # Desktop Fonts
        corefonts # MS fonts
        b612 # high legibility
        material-icons
        material-design-icons
        work-sans
        comic-neue
        source-sans
        inter
        lexend

        # Emojis
        noto-fonts-color-emoji
        twemoji-color-font

        # Nerd Fonts
        (nerdfonts.override {
          fonts = [
            "CascadiaCode"
            "Iosevka"
            "Monaspace"
            "NerdFontsSymbolsOnly"
          ];
        })
      ];

      enableDefaultPackages = true;

      fontconfig = {
        # allowType1 = true;
        # Defaults to true, but be explicit
        antialias = true;
        hinting.enable = true;

        defaultFonts =
          let
            common = [
              "MonaspiceNe Nerd Font"
              "CaskaydiaCove Nerd Font Mono"
              "Iosevka Nerd Font"
              "Symbols Nerd Font"
              "Noto Color Emoji"
            ];
          in
          mapAttrs (_: fonts: fonts ++ common) {
            serif = [ "Noto Serif" ];
            sansSerif = [ "Lexend" ];
            emoji = [ "Noto Color Emoji" ];
            monospace = [
              "Source Code Pro Medium"
              "Source Han Mono"
            ];
          };
      };
    };
  };
}