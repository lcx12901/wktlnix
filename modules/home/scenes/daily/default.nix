{
  config,
  osConfig,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  persist = osConfig.${namespace}.system.persist.enable;

  cfg = config.${namespace}.scenes.daily;
in {
  options.${namespace}.scenes.daily = {
    enable = mkBoolOpt false "Whether or not to enable daily configuration.";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      telegram-desktop
      (wechat-uos.override {
        uosLicense = fetchurl {
          # https://github.com/NixOS/nixpkgs/pull/305929
          url = "https://aur.archlinux.org/cgit/aur.git/plain/license.tar.gz?h=wechat-uos-bwrap";
          hash = "sha256-U3YAecGltY8vo9Xv/h7TUjlZCyiIQdgSIp705VstvWk=";
        };
      })
    ];

    home.persistence = mkIf persist {
      "/persist/home/${config.${namespace}.user.name}" = {
        directories = [".local/share/TelegramDesktop"];
      };
    };
  };
}
