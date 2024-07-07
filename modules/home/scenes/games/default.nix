{
  osConfig,
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt enabled;

  persist = osConfig.${namespace}.system.persist.enable;

  cfg = config.${namespace}.scenes.games;
in {
  options.${namespace}.scenes.games = {
    enable = mkBoolOpt false "Whether or not to enable common games configuration.";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      bottles
      lutris
      proton-caller
      protontricks
      protonup-ng
      protonup-qt
    ];

    wktlnix = {
      programs = {
        terminal = {
          tools = {
            wine = enabled;
          };
        };
      };
    };

    home.persistence = mkIf persist {
      "/persist/home/${config.${namespace}.user.name}" = {
        directories = [
          ".local/share/bottles"
          ".local/share/lutris"
          "Games"
        ];
      };
    };
  };
}
