{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkIf;

  cfg = config.${namespace}.hardware.gpu.amd;
in
{
  options.${namespace}.hardware.gpu.amd = {
    enable = lib.mkEnableOption "Whether or not to enable support for amdgpu.";
    enableRocmSupport = lib.mkEnableOption "support for rocm";
  };

  config = mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
      amdgpu_top
      nvtopPackages.amd
    ];

    # enables AMDVLK & OpenCL support
    hardware = {
      amdgpu = {
        amdvlk = {
          enable = false;

          support32Bit = {
            enable = true;
          };

          supportExperimental.enable = true;
        };
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
  };
}
