{
  osConfig,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.wktlnix) enabled;

  osCfg = osConfig.wktlnix.theme.stylix;
  osStylix = osConfig.stylix;
in
{
  config = lib.mkIf osCfg.enable {
    stylix = {
      enable = true;
      autoEnable = false;

      inherit (osStylix)
        image
        base16Scheme
        cursor
        fonts
        polarity
        ;

      iconTheme = {
        enable = true;
        package = pkgs.catppuccin-papirus-folders.override {
          accent = "lavender";
          flavor = "mocha";
        };
        dark = "Papirus-Dark";
        light = "Papirus-Dark";
      };

      targets = {
        bat = enabled;
        btop = enabled;
        cava = {
          enable = true;
          rainbow = enabled;
        };
        fcitx5 = enabled;
        firefox = {
          enable = true;
          profileNames = [ config.wktlnix.user.name ];
          firefoxGnomeTheme = enabled;
        };
        fish = enabled;
        fzf = enabled;
        gnome = enabled;
        gtk = enabled;
        kitty = {
          enable = true;
          variant256Colors = true;
        };
        lazygit = enabled;
        nvf = enabled;
        qt = enabled;
        vesktop = enabled;
        vscode = {
          enable = true;
          profileNames = [
            "default"
            "Vue"
          ];
        };
        yazi = enabled;
        zed = enabled;
      };
    };
  };
}
