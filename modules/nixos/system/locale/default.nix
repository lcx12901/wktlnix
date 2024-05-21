{ config, lib, pkgs, ... }: let
  inherit (lib) mkIf mkDefault types;
  inherit (lib.internal) mkOpt mkBoolOpt;

  cfg = config.wktlNix.system.locale;
in {
  options.wktlNix.system.locale = {
    enable = mkBoolOpt true "Whether or not to manage locale settings.";
    inputMethod = mkOpt (types.nullOr types.str) null "Select the enabled input method.";
  };

  config = mkIf cfg.enable {
    services.xserver.xkb = {
      layout = "us";
      variant = "";
    };

    i18n = let
      defaultLocale = "en_US.UTF-8";
      zh = "zh_CN.UTF-8";
    in {
      inherit defaultLocale;

      extraLocaleSettings = {
        LANG = defaultLocale;
        LC_COLLATE = defaultLocale;
        LC_CTYPE = defaultLocale;
        LC_MESSAGES = defaultLocale;

        LC_ADDRESS = zh;
        LC_IDENTIFICATION = zh;
        LC_MEASUREMENT = zh;
        LC_MONETARY = zh;
        LC_NAME = zh;
        LC_NUMERIC = zh;
        LC_PAPER = zh;
        LC_TELEPHONE = zh;
        LC_TIME = zh;
      };

      supportedLocales = mkDefault [
        "en_US.UTF-8/UTF-8"
        "zh_CN.UTF-8/UTF-8"
      ];

      # ime configuration
      inputMethod = {
        enabled = cfg.inputMethod; # Needed for fcitx5 to work in qt6
        fcitx5.addons = with pkgs; [
          fcitx5-gtk
          fcitx5-lua
          libsForQt5.fcitx5-qt

          # themes
          fcitx5-material-color
        ];
      };
    };
  };
}