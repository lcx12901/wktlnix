{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf mkDefault;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.system.locale;
in {
  options.${namespace}.system.locale = {
    enable = mkBoolOpt false "Whether or not to manage locale settings.";
  };

  config = mkIf cfg.enable {
    services.xserver.xkb = {
      layout = "us";
      variant = "";
    };

    i18n = let
      defaultLocale = "zh_CN.UTF-8";
      zh = "zh_CN.UTF-8";
    in {
      inherit defaultLocale;

      extraLocaleSettings = {
        LANG = zh;
        LC_COLLATE = zh;
        LC_CTYPE = zh;
        LC_MESSAGES = zh;

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
    };
  };
}
