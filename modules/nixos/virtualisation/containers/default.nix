{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf optionalString;
  inherit (lib.${namespace}) mkBoolOpt;

  hasOptinPersistence = config.${namespace}.system.persist.enable;

  username = config.${namespace}.user.name;

  volumesRoot = "${optionalString hasOptinPersistence "/persist"}/home/${username}/.containers";

  cfg = config.${namespace}.virtualisation.containers;
in {
  options.${namespace}.virtualisation.containers = {
    enable = mkBoolOpt false "Whether or not to enable containers.";
  };

  config = mkIf cfg.enable {
    # Before creating a container, you need to have a mounting directory
    environment = {
      persistence."/persist" = mkIf hasOptinPersistence {
        users."${username}" = {
          directories = [
            ".containers"
          ];
        };
      };
    };

    virtualisation.oci-containers.containers = {
      ddns-go = {
        image = "jeessy/ddns-go:latest";
        autoStart = true;
        volumes = ["${volumesRoot}/ddns-go:/root"];
        extraOptions = ["--network=host" "--pull=newer"];
      };

      aria2-pro = {
        image = "p3terx/aria2-pro:latest";
        autoStart = true;
        environmentFiles = [config.age.secrets."aria2.env".path];
        volumes = [
          "${volumesRoot}/aria2/config:/config"
          "${volumesRoot}/aria2/download:/downloads"
        ];
        environment = {
          IPV6_MODE = "true";
        };
        extraOptions = ["--network=host" "--log-opt=max-size=1m" "--pull=newer"];
      };
      ariang = {
        image = "p3terx/ariang:latest";
        autoStart = true;
        extraOptions = ["--network=host" "--log-opt=max-size=1m" "--pull=newer"];
      };
    };

    networking.firewall.allowedTCPPorts = [9876];
  };
}
