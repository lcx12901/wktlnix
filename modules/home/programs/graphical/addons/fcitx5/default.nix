{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.wktlnix.programs.graphical.addons.fcitx5;
in
{
  options.wktlnix.programs.graphical.addons.fcitx5 = {
    enable = mkEnableOption "Whether to enable fcitx5.";
  };

  config = mkIf cfg.enable {
    home.sessionVariables = {
      GTK_IM_MODULE = lib.mkForce "";
      SDL_IM_MODULE = "fcitx";
    };

    gtk = {
      gtk2.extraConfig = ''
        gtk-im-module=fcitx
      '';
      gtk3.extraConfig = {
        gtk-im-module = "fcitx";
      };
      gtk4.extraConfig = {
        gtk-im-module = "fcitx";
      };
    };

    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5 = {
        addons = with pkgs; [
          kdePackages.fcitx5-chinese-addons
          fcitx5-gtk
          libsForQt5.fcitx5-qt
          fcitx5-lua
          fcitx5-pinyin-zhwiki
          fcitx5-pinyin-moegirl
        ];

        waylandFrontend = true;
      };
    };
  };
}
