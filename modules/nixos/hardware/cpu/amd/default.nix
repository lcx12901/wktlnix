{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.wktlnix.hardware.cpu.amd;
in
{
  options.wktlnix.hardware.cpu.amd = {
    enable = mkEnableOption "Whether or not to enable support for amd cpu.";
  };

  config = mkIf cfg.enable {
    boot = {
      extraModulePackages = [ config.boot.kernelPackages.zenpower ];

      kernelModules = [
        "kvm-amd" # amd virtualization
        "zenpower" # zenpower is for reading cpu info, i.e voltage
        "msr" # x86 CPU MSR access device
      ];

      kernelParams = [ "amd_pstate=active" ];
    };

    environment.systemPackages = [ pkgs.amdctl ];

    hardware.cpu.amd.updateMicrocode = true;
  };
}
