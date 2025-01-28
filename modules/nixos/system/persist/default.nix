{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.system.persist;

  username = config.${namespace}.user.name;
in
{
  options.${namespace}.system.persist = {
    enable = mkBoolOpt false "Whether or not to enable impermanence.";
  };

  config = mkIf cfg.enable {
    environment.persistence."/persist" = {
      hideMounts = true;

      directories = [
        "/etc/ssh"
        "/var/lib"
        "/var/log"
      ];

      files = [ "/etc/machine-id" ];

      users."${username}" = {
        directories = [
          "Coding"
          "Downloads"
          "Documents"
          "Music"
          "Pictures"
        ];

        files = [ ".ssh/id_ed25519" ];
      };
    };

    programs.fuse.userAllowOther = true;
  };
}
