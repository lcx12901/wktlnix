{
  config,
  lib,
  inputs,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf mkMerge;
  inherit (lib.${namespace}) mkBoolOpt;

  hasOptinPersistence = config.${namespace}.system.persist.enable;
  # hasMyContainer = containerName: lib.hasAttr containerName config.virtualisation.oci-containers.containers;

  cfg = config.${namespace}.secrets.age;
in {
  options.${namespace}.secrets.age = {
    enable = mkBoolOpt true "Whether or not to enable agenix.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      inputs.agenix.packages."${pkgs.system}".default
    ];

    age.identityPaths = [
      "${lib.optionalString hasOptinPersistence "/persist"}/etc/ssh/ssh_host_ed25519_key"
    ];

    age.secrets = mkMerge [
      (mkIf config.${namespace}.security.acme.enable {
        "cloudflare.key" = {
          file = lib.snowfall.fs.get-file "secrets/keys/cloudflare.age";
        };
      })
      (mkIf config.services.dae.enable {
        "config.dae" = {
          file = lib.snowfall.fs.get-file "secrets/service/dae.age";
        };
      })
      (mkIf config.${namespace}.services.mihomo.enable {
        "mihomo.yaml" = {
          file = lib.snowfall.fs.get-file "secrets/service/mihomo.age";
        };
      })
      (mkIf config.${namespace}.services.aria2.enable {
        "aria2-rpc-token.text" = {
          file = lib.snowfall.fs.get-file "secrets/keys/aria2.age";
        };
      })
      (mkIf config.${namespace}.services.inadyn.enable {
        "cf-nagisa-inadyn.conf" = {
          file = lib.snowfall.fs.get-file "secrets/service/cf-nagisa-inadyn.age";
          owner = config.services.inadyn.user;
          group = config.services.inadyn.group;
        };
      })

      {
        "akari_rsa" = {
          file = lib.snowfall.fs.get-file "secrets/ssh/akari_rsa.age";
          owner = config.${namespace}.user.name;
          group = "users";
          mode = "0600";
        };
      }
      {
        "host_rsa" = {
          file = lib.snowfall.fs.get-file "secrets/ssh/host_rsa.age";
          owner = config.${namespace}.user.name;
          group = "users";
          mode = "0600";
        };
      }
    ];
  };
}
