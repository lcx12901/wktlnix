{ config, lib, ... }:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.wktlnix.system.boot;
in
{
  options.wktlnix.system.boot = {
    enable = mkEnableOption "Whether or not to enable booting.";
    silentBoot = mkEnableOption "Whether or not to enable silent boot.";
    useOSProber = mkEnableOption "Whether or not to append entries for other OSs detected by os-prober.";
  };

  config = mkIf cfg.enable {
    boot = {
      initrd.systemd.network.wait-online.enable = false;

      kernelParams = lib.optionals cfg.silentBoot [
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
          canTouchEfiVariables = false;
          efiSysMountPoint = "/boot";
        };

        generationsDir.copyKernels = true;

        grub = {
          inherit (cfg) useOSProber;

          enable = true;
          default = "saved";
          devices = [ "nodev" ];
          efiSupport = true;
          efiInstallAsRemovable = true;
        };
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
