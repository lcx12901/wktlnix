{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.programs.graphical.games.gamescope;
in
{
  options.${namespace}.programs.graphical.games.gamescope = {
    enable = lib.mkEnableOption "Whether or not to enable gamescope.";
  };

  config = lib.mkIf cfg.enable {
    programs = {
      gamescope = {
        enable = true;
        package = pkgs.gamescope;

        capSysNice = true;
        args = [
          "--rt"
          "--expose-wayland"
        ];
      };

      steam.gamescopeSession.enable = true;
    };
  };
}
