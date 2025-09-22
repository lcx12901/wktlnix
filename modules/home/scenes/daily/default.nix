{
  config,
  osConfig,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  persist = osConfig.wktlnix.system.persist.enable;

  cfg = config.wktlnix.scenes.daily;
in
{
  options.wktlnix.scenes.daily = {
    enable = mkEnableOption "Whether or not to enable daily configuration.";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      wechat-uos
      telegram-desktop
    ];

    home.persistence = mkIf persist {
      "/persist/home/${config.wktlnix.user.name}" = {
        directories = [ ".local/share/TelegramDesktop" ];
      };
    };
  };
}
