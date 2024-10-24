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
efi = {
        number = 1;
        size = 512MiB;  # EFI 分区的大小，通常为 512MiB
        type = "efi";  # 指定为 EFI 分区类型
        filesystem = {
          format = "vfat";  # 格式化为 FAT32
          mountPoint = "/boot/efi";  # 挂载到 /boot/efi
        };
      };
              boot = {
                number = 2;
        size ="1GiB";  # /boot 分区大小，通常 512MiB 到 1GiB 即可
        type = "linux";  # Linux 分区类型
        filesystem = {
          format = "ext4";  # /boot 分区格式化为 ext4
          mountPoint = "/boot";  # 挂载到 /boot
                

              };};
              root = {
                 number = 3;
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
