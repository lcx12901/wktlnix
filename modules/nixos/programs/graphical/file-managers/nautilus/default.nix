{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.programs.graphical.file-managers.nautilus;
in {
  options.${namespace}.programs.graphical.file-managers.nautilus = {
    enable = mkBoolOpt false "Whether to enable the gnome file manager.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [gnome.nautilus];

    # Enable support for browsing samba shares.
    services.gvfs.enable = true;
  };
}
