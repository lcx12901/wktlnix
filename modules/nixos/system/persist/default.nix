{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.system.persist;

  username = config.${namespace}.user.name;
in {
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

      users."${username}" = {
        directories = [
          "Coding"
          "Downloads"
          "Documents"
          "Music"
          "Pictures"
        ];
      };
    };

    programs.fuse.userAllowOther = true;

    system.activationScripts.persistent-dirs.text = let
      mkHomePersist = user:
        lib.optionalString user.createHome ''
          mkdir -p /persist/${user.home}
          chown ${user.name}:${user.group} /persist/${user.home}
          chmod ${user.homeMode} /persist/${user.home}
        '';
      users = lib.attrValues config.users.users;
    in
      lib.concatLines (map mkHomePersist users);
  };
}
