{
  osConfig,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.wktlnix.scenes.music;

  persist = osConfig.wktlnix.system.persist.enable;
in
{
  options.wktlnix.scenes.music = {
    enable = mkEnableOption "Whether or not to enable music configuration.";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ qqmusic ];

    home.persistence = mkIf persist {
      "/persist/home/${config.wktlnix.user.name}" = {
        directories = [ ".config/qqmusic" ];
      };
    };
  };
}
