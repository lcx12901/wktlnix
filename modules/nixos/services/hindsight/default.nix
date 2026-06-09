{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    ;

  cfg = config.wktlnix.services.hindsight;

  domain = "${config.networking.hostName}.lincx.top";

  stateDir = "/var/lib/hindsight";

  # Secrets
  databasePasswordFile = config.sops.secrets."hindsight-db-password".path;

  # Fixed database parameters
  dbName = "hindsight";
  dbUser = "hindsight";
  dbPort = 5432;

  # Container image versions
  apiImage = "ghcr.io/vectorize-io/hindsight-api:latest-slim";
  cpImage = "ghcr.io/vectorize-io/hindsight-control-plane:latest";

  # Hindsight API environment (non-secret vars)
  hindsightEnv = {
    # Database URL (with password) is in sops template below
    HINDSIGHT_API_DATABASE_SCHEMA = "public";
    HINDSIGHT_API_VECTOR_EXTENSION = "pgvector";

    # LLM Configuration (opencode-go)
    HINDSIGHT_API_LLM_PROVIDER = "opencode-go";
    HINDSIGHT_API_LLM_MODEL = "mimo-v2.5";
    HINDSIGHT_API_LLM_BASE_URL = "https://opencode.ai/zen/go/v1";

    # Embeddings Configuration (SiliconFlow)
    HINDSIGHT_API_EMBEDDINGS_PROVIDER = "openai";
    HINDSIGHT_API_EMBEDDINGS_OPENAI_BASE_URL = "https://api.siliconflow.cn/v1";
    HINDSIGHT_API_EMBEDDINGS_OPENAI_MODEL = "BAAI/bge-m3";

    # Reranker Configuration (SiliconFlow) — required for slim image
    HINDSIGHT_API_RERANKER_PROVIDER = "cohere";
    HINDSIGHT_API_RERANKER_COHERE_BASE_URL = "https://api.siliconflow.cn/v1/rerank";
    HINDSIGHT_API_RERANKER_COHERE_MODEL = "Qwen/Qwen3-Reranker-8B";

    # Authentication: built-in API key tenant extension
    HINDSIGHT_API_TENANT_EXTENSION = "hindsight_api.extensions.builtin.tenant:ApiKeyTenantExtension";

    # Worker: single process (default)
    HINDSIGHT_API_WORKERS = "1";

    # Data directory
    HINDSIGHT_API_DATA_DIR = stateDir;
  };
in
{
  options.wktlnix.services.hindsight = {
    enable = mkEnableOption "Whether to enable Hindsight memory service.";
  };

  config = mkIf cfg.enable {
    # PostgreSQL configuration
    services.postgresql = {
      enable = true;

      package = pkgs.postgresql_17;

      extensions = with pkgs.postgresql17Packages; [
        pgvector
      ];

      # Declarative database and user management (like nextcloud)
      ensureDatabases = [ dbName ];
      ensureUsers = [
        {
          name = dbUser;
          ensureDBOwnership = true;
        }
      ];

      # pg_hba.conf entries for local Hindsight database access
      authentication = lib.mkAfter ''
        local ${dbName} ${dbUser} md5
        host ${dbName} ${dbUser} 127.0.0.1/32 md5
        host ${dbName} ${dbUser} ::1/128 md5
      '';
    };

    # Set password and enable pgvector extension
    systemd.services.hindsight-db-setup = {
      description = "Setup Hindsight database (password + extensions)";
      after = [ "postgresql.service" ];
      requires = [ "postgresql.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        User = "postgres";
        LoadCredential = "hindsight-db-password:${databasePasswordFile}";
      };
      script =
        let
          psql = "${config.services.postgresql.package}/bin/psql";
        in
        ''
          DB_PASSWORD=$(cat "$CREDENTIALS_DIRECTORY/hindsight-db-password")

          # Set password for hindsight user
          ${psql} -c "ALTER USER ${dbUser} WITH PASSWORD '$DB_PASSWORD'"

          # Enable pgvector extension in public schema
          ${psql} -d ${dbName} -c "CREATE EXTENSION IF NOT EXISTS vector SCHEMA public"

          # Enable pg_trgm extension in public schema (required for trigram indexes)
          ${psql} -d ${dbName} -c "CREATE EXTENSION IF NOT EXISTS pg_trgm SCHEMA public"
        '';
    };

    # OCI containers
    virtualisation.oci-containers = {
      containers = {
        # Hindsight API container
        hindsight-api = {
          image = apiImage;
          ports = [ "8888:8888" ];
          environment = hindsightEnv;
          environmentFiles = [ config.sops.templates."hindsight-env".path ];
          volumes = [
            "${stateDir}:/home/nonroot/.hindsight"
          ];
          dependsOn = [ ]; # No container dependencies, but systemd handles DB setup
          extraOptions = [
            "--network=host"
          ];
        };

        # Hindsight Control Plane container
        hindsight-cp = {
          image = cpImage;
          ports = [ "9999:9999" ];
          environment = {
            HINDSIGHT_CP_DATAPLANE_API_URL = "http://localhost:8888";
            PORT = "9999";
          };
          environmentFiles = [ config.sops.templates."hindsight-cp-env".path ];
          dependsOn = [ "hindsight-api" ];
          extraOptions = [
            "--network=host"
          ];
        };
      };
    };

    # Ensure API container starts after DB setup
    systemd.services."podman-hindsight-api" = {
      after = [ "hindsight-db-setup.service" ];
      requires = [ "hindsight-db-setup.service" ];
    };

    # Secrets
    sops = {
      secrets = {
        "hindsight-db-password" = { };
        "OPENCODE_API_KEY" = { };
        "siliconflow-api-key" = { };
        "hindsight-tenant-api-key" = { };
        "hindsight-cp-access-key" = { };
      };
      templates = {
        "hindsight-env".content = ''
          HINDSIGHT_API_DATABASE_URL=postgresql://${dbUser}:${
            config.sops.placeholder."hindsight-db-password"
          }@localhost:${toString dbPort}/${dbName}
          HINDSIGHT_API_LLM_API_KEY=${config.sops.placeholder."OPENCODE_API_KEY"}
          HINDSIGHT_API_EMBEDDINGS_OPENAI_API_KEY=${config.sops.placeholder."siliconflow-api-key"}
          HINDSIGHT_API_RERANKER_COHERE_API_KEY=${config.sops.placeholder."siliconflow-api-key"}
          HINDSIGHT_API_TENANT_API_KEY=${config.sops.placeholder."hindsight-tenant-api-key"}
        '';
        "hindsight-cp-env".content = ''
          HINDSIGHT_CP_DATAPLANE_API_KEY=${config.sops.placeholder."hindsight-tenant-api-key"}
          HINDSIGHT_CP_ACCESS_KEY=${config.sops.placeholder."hindsight-cp-access-key"}
        '';
      };
    };

    # Persistence
    environment.persistence."/persist" = {
      hideMounts = true;

      directories = [
        stateDir
        "/var/lib/postgresql"
        "/var/lib/containers"
      ];
    };

    # Nginx reverse proxy
    services.nginx.virtualHosts = mkIf config.wktlnix.services.nginx.enable {
      "hindsight.${domain}" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:8888";
          proxyWebsockets = true;
        };
      };

      "hindsight-ui.${domain}" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:9999";
          proxyWebsockets = true;
        };
      };
    };
  };
}
