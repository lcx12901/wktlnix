{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf types;
  inherit (lib.${namespace}) mkOpt mkBoolOpt;

  cfg = config.${namespace}.system.disko;

  isGrub = config.${namespace}.system.boot.useGrub;
in {
  options.${namespace}.system.disko = {
    enable = mkBoolOpt false "Whether or not to enable declarative disk partitioning.";
    device = mkOpt types.str "/dev/nvme0n1" "this is a disk path.";
    rootSize = mkOpt types.str "100%" "this is a root partition size.";
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
              efi = mkIf isGrub {
                size = "512M"; # EFI 分区的大小，通常为 512MiB
                type = "EF00"; # 指定为 EFI 分区类型
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot/efi";
                };
              };
              boot = mkIf isGrub {
                size = "1G"; # /boot 分区大小，通常 512MiB 到 1GiB 即可
                content = {
                  type = "filesystem";
                  format = "ext4";
                  mountpoint = "/boot";
                };
              };

              ESP = mkIf (!isGrub) {
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
                size = cfg.rootSize;
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
