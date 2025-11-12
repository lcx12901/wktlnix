{ config, lib, ... }:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.wktlnix.system.persist;

  username = config.wktlnix.user.name;
in
{
  options.wktlnix.system.persist = {
    enable = mkEnableOption "Whether or not to enable impermanence.";
    userDirs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "List of user directories to persist.";
    };
  };

  config = mkIf cfg.enable {
    environment.persistence."/persist" = {
      hideMounts = true;

      directories = [
        "/var/lib/nixos"
        "/var/log"
      ];

      files = [
        "/etc/machine-id"
        "/etc/ssh/ssh_host_ed25519_key"
      ];

      users."${username}" = {
        directories = cfg.userDirs;

        files = [ ".ssh/id_ed25519" ];
      };
    };

    programs.fuse.userAllowOther = true;
  };
}
