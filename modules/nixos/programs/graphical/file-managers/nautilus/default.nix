{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.wktlnix.programs.graphical.file-managers.nautilus;
in
{
  options.wktlnix.programs.graphical.file-managers.nautilus = {
    enable = mkEnableOption "Whether to enable the gnome file manager.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ nautilus ];

    # Enable support for browsing samba shares.
    services.gvfs.enable = true;
  };
}
