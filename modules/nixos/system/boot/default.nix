{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.system.boot;
in {
  options.${namespace}.system.boot = {
    enable = mkBoolOpt false "Whether or not to enable booting.";
    plymouth = mkBoolOpt false "Whether or not to enable plymouth boot splash.";
    silentBoot = mkBoolOpt false "Whether or not to enable silent boot.";
    useGrub = mkBoolOpt false "Whether or not to use grub instead of systemd-boot.";
  };

  config = mkIf cfg.enable {
    boot = {
      kernelParams =
        lib.optionals cfg.plymouth ["quiet"]
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
          efiSysMountPoint =
            if cfg.useGrub
            then "/boot/efi"
            else "/boot";
        };

        generationsDir.copyKernels = true;

        systemd-boot = {
          enable = !cfg.useGrub;
          configurationLimit = 20;
          editor = false;
        };

        grub = {
          enable = cfg.useGrub;
          device = "nodev";
          efiSupport = true;
          useOSProber = true;
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

    systemd = {
      # given that our systems are headless, emergency mode is useless.
      # we prefer the system to attempt to continue booting so
      # that we can hopefully still access it remotely.
      enableEmergencyMode = false;

      # For more detail, see:
      #   https://0pointer.de/blog/projects/watchdog.html
      watchdog = {
        # systemd will send a signal to the hardware watchdog at half
        # the interval defined here, so every 10s.
        # If the hardware watchdog does not get a signal for 20s,
        # it will forcefully reboot the system.
        runtimeTime = "20s";
        # Forcefully reboot if the final stage of the reboot
        # hangs without progress for more than 30s.
        # For more info, see:
        #   https://utcc.utoronto.ca/~cks/space/blog/linux/SystemdShutdownWatchdog
        rebootTime = "30s";
      };

      sleep.extraConfig = ''
        AllowSuspend=no
        AllowHibernation=no
      '';
    };
  };
}
