{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf types;
  inherit (lib.${namespace}) mkOpt mkBoolOpt;

  cfg = config.${namespace}.system.disko;
in {
  options.${namespace}.system.disko = {
    enable = mkBoolOpt false "Whether or not to enable declarative disk partitioning.";
    device = mkOpt types.str "/dev/nvme0n1" "this is a disk path.";
  };

  config = mkIf cfg.enable {
    disko.devices = {
      nodev."/" = {
        fsType = "tmpfs";
        mountOptions = [
          "defaults"
          "size=4G"
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
                      swap.swapfile.size = "16G";
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
