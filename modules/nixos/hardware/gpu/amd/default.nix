{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.wktlnix.hardware.gpu.amd;
in
{
  options.wktlnix.hardware.gpu.amd = {
    enable = mkEnableOption "Whether or not to enable support for amdgpu.";
    enableRocmSupport = mkEnableOption "support for rocm";
  };

  config = mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
      amdgpu_top
      nvtopPackages.amd
    ];

    # enables AMDVLK & OpenCL support
    hardware = {
      amdgpu = {
        initrd.enable = true;
        opencl.enable = true;
        overdrive.enable = true;
      };

      graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = with pkgs; [
          vulkan-tools
          rocmPackages.clr.icd
        ];
      };
    };

    nixpkgs.config.rocmSupport = cfg.enableRocmSupport;

    # Allow userspace tools (like gamemode) to control GPU performance
    services.udev.extraRules = ''
      KERNEL=="card[0-9]", SUBSYSTEM=="drm", ACTION=="add", RUN+="${pkgs.coreutils}/bin/chmod 666 /sys/class/drm/%k/device/power_dpm_force_performance_level"
    '';
  };
}
