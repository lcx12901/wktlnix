{
  osConfig,
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.scenes.music;

  persist = osConfig.${namespace}.system.persist.enable;
in
{
  options.${namespace}.scenes.music = {
    enable = mkBoolOpt false "Whether or not to enable music configuration.";
  };

  config = mkIf cfg.enable {
    wktlnix = {
      programs = {
        terminal = {
          media = {
            # spicetify = enabled;
            # go-musicfox = enabled;
          };
        };
      };
    };

    home.packages = with pkgs; [ qqmusic ];

    home.persistence = mkIf persist {
      "/persist/home/${config.${namespace}.user.name}" = {
        directories = [ ".config/qqmusic" ];
      };
    };

  };
}
