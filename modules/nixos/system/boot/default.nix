{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.system.boot;
in
{
  options.${namespace}.system.boot = {
    enable = mkBoolOpt false "Whether or not to enable booting.";
    plymouth = mkBoolOpt false "Whether or not to enable plymouth boot splash.";
    silentBoot = mkBoolOpt false "Whether or not to enable silent boot.";
    useGrub = mkBoolOpt false "Whether or not to use grub instead of systemd-boot.";
  };

  config = mkIf cfg.enable {
    boot = {
      initrd.systemd.network.wait-online.enable = false;

      kernelParams =
        lib.optionals cfg.plymouth [
          "quiet"
          "splash"
        ]
        ++ lib.optionals cfg.silentBoot [
          # tell the kernel to not be verbose
          "quiet"

          # kernel log message level
          "loglevel=3" # 1: system is unusable | 3: error condition | 7: very verbose

          # udev log message level
          "udev.log_level=3"

          # lower the udev log level to show only errors or worse
          "rd.udev.log_level=3"

          # disable systemd status messages
          # rd prefix means systemd-udev will be used instead of initrd
          "systemd.show_status=auto"
          "rd.systemd.show_status=auto"

          # disable the cursor in vt to get a black screen during intermissions
          "vt.global_cursor_default=0"
        ];

      kernel.sysctl = {
        "kernel.sysrq" = 1;
        "vm.swappiness" = 10;
      };

      loader = {
        efi = {
          canTouchEfiVariables = !cfg.useGrub;
          efiSysMountPoint = "/boot";
        };

        generationsDir.copyKernels = true;

        systemd-boot = {
          enable = !cfg.useGrub;
          configurationLimit = 20;
          editor = false;
        };

        grub = {
          enable = cfg.useGrub;
          default = "saved";
          devices = [ "nodev" ];
          efiSupport = true;
          efiInstallAsRemovable = true;
        };
      };

      plymouth = {
        enable = cfg.plymouth;
        theme = "sphere";
        themePackages = [
          (pkgs.adi1090x-plymouth-themes.override {
            selected_themes = [
              "pixels"
              "sphere"
            ];
          })
        ];
      };

      supportedFilesystems = [
        "ext4"
        "btrfs"
        "xfs"
        "ntfs"
        "fat"
        "vfat"
        "cifs" # mount windows share
      ];
    };

    services.fwupd = {
      enable = true;
      daemonSettings.EspLocation = config.boot.loader.efi.efiSysMountPoint;
    };
  };
}
