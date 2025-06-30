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

    environment.variables = {
      # VAAPI and VDPAU config for accelerated video.
      # See https://wiki.archlinux.org/index.php/Hardware_video_acceleration
      "VDPAU_DRIVER" = "radeonsi";
      "LIBVA_DRIVER_NAME" = "radeonsi";
    };

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
      };
      graphics = {
        enable = true;

        extraPackages = with pkgs; [
          # mesa
          mesa

          vulkan-tools
          vulkan-loader
          vulkan-validation-layers
          vulkan-extension-layer
        ];
      };
    };

    nixpkgs.config.rocmSupport = cfg.enableRocmSupport;

    services.xserver.videoDrivers = lib.mkDefault [
      "modesetting"
    ];
  };
}
