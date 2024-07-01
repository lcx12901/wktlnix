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

  cfg = config.${namespace}.secrets.age;
  hasOptinPersistence = config.${namespace}.system.persist.enable;
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
      (mkIf config.services.dae.enable {
        "config.dae" = {
          file = lib.snowfall.fs.get-file "secrets/service/dae.age";
        };
      })
      (mkIf config.${namespace}.security.acme.enable {
        "cloudflare.key" = {
          file = lib.snowfall.fs.get-file "secrets/keys/cloudflare.age";
        };
      })
      (mkIf config.${namespace}.services.mihomo.enable {
        "mihomo.yaml" = {
          file = lib.snowfall.fs.get-file "secrets/service/mihomo.age";
        };
      })
      (mkIf config.services.nginx.enable {
        "nezuko.pem" = {
          file = lib.snowfall.fs.get-file "secrets/ssl/nezuko.pem.age";
        };
        "nezuko.key" = {
          file = lib.snowfall.fs.get-file "secrets/ssl/nezuko.key.age";
        };
      })
    ];
  };
}
