{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.services.databases.postgresql;
in {
  options.${namespace}.services.databases.postgresql = {
    enable = mkBoolOpt false "Whether or not to open the postgresql database.";
  };

  config = mkIf cfg.enable {
    services.postgresql = {
      enable = true;
      package = pkgs.postgresql_15;

      ensureDatabases = [
        (mkIf config.services.nextcloud.enable "nextcloud")
      ];

      ensureUsers = [
        {
          name = "postgres";
          ensureClauses = {
            superuser = true;
            login = true;
            createrole = true;
            createdb = true;
            replication = true;
          };
        }
        (mkIf config.services.nextcloud.enable {
          name = "nextcloud";
          ensureDBOwnership = true;
        })
      ];

      checkConfig = true;
      enableTCPIP = false;
    };
  };
}
