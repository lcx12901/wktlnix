{
  osConfig,
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib.${namespace}) enabled;
  osCfg = osConfig.${namespace}.theme.stylix;
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
        firefox = {
          enable = true;
          profileNames = [ config.${namespace}.user.name ];
          firefoxGnomeTheme = enabled;
        };
        btop = enabled;
        bat = enabled;
        cava = {
          enable = true;
          rainbow = enabled;
        };
        fcitx5 = enabled;
        fish = enabled;
        fzf = enabled;
        kitty = {
          enable = true;
          variant256Colors = true;
        };
        lazygit = enabled;
        nvf = enabled;
        vscode = {
          enable = true;
          profileNames = [
            "default"
            "Vue"
          ];
        };
        yazi = enabled;
        zed = enabled;
        gnome = enabled;
        gtk = enabled;
        qt = enabled;
      };
    };
  };
}
