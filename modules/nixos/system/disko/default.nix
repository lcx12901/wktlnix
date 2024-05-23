{config, lib, ...}: let 
  inherit (lib) mkIf types;
  inherit (lib.internal) mkOpt mkBoolOpt;

  cfg = config.wktlNix.system.disko;
in {
  options.wktlNix.system.disko = {
    enable = mkBoolOpt false "Whether or not to enable declarative disk partitioning.";
    device = mkOpt types.str "/dev/nvme0n1" "this is a disk path.";
  };

  config = mkIf cfg.enable {
    disko.devices = {};
  };
}