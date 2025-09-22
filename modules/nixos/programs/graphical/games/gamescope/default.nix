{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.wktlnix.programs.graphical.games.gamescope;
in
{
  options.wktlnix.programs.graphical.games.gamescope = {
    enable = mkEnableOption "Whether or not to enable gamescope.";
  };

  config = mkIf cfg.enable {
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
