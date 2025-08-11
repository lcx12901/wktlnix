{
  config,
  lib,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.programs.graphical.addons.dconf;
in
{
  options.${namespace}.programs.graphical.addons.dconf = {
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
