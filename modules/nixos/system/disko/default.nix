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
    disko.devices = {
      nodev."/" = {
        fsType = "tmpfs";
        mountOptions = [
          "defaults"
          "size=32G"
          "mode=755"
        ];
      };
      disk = {
        main = {
          type = "disk";
          device = cfg.device;
          content = {
            type = "gpt";
            partitions = {
              ESP = {
                priority = 1;
                name = "ESP";
                start = "1M";
                end = "512M";
                type = "EF00";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
                };
              };
              root = {
                size = "100%";
                content = {
                  type = "btrfs";
                  extraArgs = ["-f"];
                  subvolumes = {
                    nix = {
                      mountpoint = "/nix";
                      mountOptions = ["compress-force=zstd:1" "noatime"];
                    };
                    persist = {
                      mountpoint = "/persist";
                      mountOptions = ["compress-force=zstd:1" "noatime"];
                    };
                    tmp = {
                      mountpoint = "/tmp";
                      mountOptions = ["noatime"];
                    };
                    swap = {
                      mountpoint = "/swap";
                      mountOptions = ["noatime"];
                      swap.swapfile.size = "64G";
                    };
                  };
                };
              };
            };
          };
        };
      };
    };

    fileSystems."/persist" = {
      neededForBoot = true;
    };
  };
}