{ config, lib, ... }:
let
  cfg = config.home.programs.graphical.addons.dconf;
in
{
  options.home.programs.graphical.addons.dconf = {
    enable = lib.mkEnableOption "dconf settings";
  };

  config = lib.mkIf cfg.enable {
    dconf = {
      settings = {
        "org/virt-manager/virt-manager/connections" = {
          autoconnect = [ "qemu:///system" ];
          uris = [ "qemu:///system" ];
        };
      };
    };
  };
}
