{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkIf types;
  inherit (lib.${namespace}) mkOpt mkBoolOpt;

  cfg = config.${namespace}.system.disko;

in
{
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
          "relatime"
          "mode=755"
          "nosuid"
          "nodev"
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
                size = "512M";
                type = "EF00";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
                  mountOptions = [ "umask=0077" ];
                };
              };
              root = {
                size = cfg.rootSize;
                content = {
                  type = "btrfs";
                  extraArgs = [ "-f" ];
                  subvolumes = {
                    nix = {
                      mountpoint = "/nix";
                      mountOptions = [
                        "compress-force=zstd:1"
                        "noatime"
                      ];
                    };
                    persist = {
                      mountpoint = "/persist";
                      mountOptions = [
                        "compress-force=zstd:1"
                        "noatime"
                      ];
                    };
                    tmp = {
                      mountpoint = "/tmp";
                      mountOptions = [ "noatime" ];
                    };
                    swap = {
                      mountpoint = "/swap";
                      mountOptions = [ "noatime" ];
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
