{
  # osConfig,
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.programs.graphical.video;
in
# persist = osConfig.${namespace}.system.persist.enable;
{
  options.${namespace}.programs.graphical.video = {
    enable = mkBoolOpt false "Whether or not to enable video configuration.";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      ffmpeg-full
      vlc
      tsukimi
    ];

    # home.persistence = mkIf persist {
    #   "/persist/home/${config.${namespace}.user.name}" = {
    #     allowOther = true;
    #     files = [".config/tsukimi.toml"];
    #   };
    # };
  };
}
