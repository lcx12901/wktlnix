{ config, lib, ... }:
let
  inherit (lib) mkIf mkEnableOption types;
  inherit (lib.wktlnix) mkOpt;

  cfg = config.wktlnix.services.obsidian-backup;
in
{
  options.wktlnix.services.obsidian-backup = {
    enable = mkEnableOption "Encrypted Restic backups of Obsidian vault to Cloudflare R2.";

    timerConfig = mkOpt types.attrs {
      OnCalendar = "weekly";
      Persistent = true;
    } "systemd timer configuration.";

    pruneOpts = mkOpt (types.listOf types.str) [
      "--keep-daily 7"
      "--keep-weekly 4"
      "--keep-monthly 6"
      "--keep-yearly 2"
    ] "Restic prune options.";
  };

  config = mkIf cfg.enable {
    services.restic.backups.obsidian-vault = {
      initialize = true;

      repository = "s3:https://ca43baa3381f83df8e3244bb4fdc7154.r2.cloudflarestorage.com/obsidian-backup";

      environmentFile = config.sops.templates."obsidian-backup-r2.env".path;
      passwordFile = config.sops.secrets."obsidian-backup/restic_password".path;

      paths = [ "/var/lib/couchdb" ];

      inherit (cfg) pruneOpts timerConfig;

      extraBackupArgs = [
        "--verbose"
      ];
    };

    sops.secrets =
      let
        sopsFile = lib.file.get-file "secrets/obsidian.yaml";
      in
      {
        "obsidian-backup/r2_access_key" = {
          inherit sopsFile;
        };
        "obsidian-backup/r2_secret_key" = {
          inherit sopsFile;
        };
        "obsidian-backup/restic_password" = {
          inherit sopsFile;
        };
      };

    sops.templates."obsidian-backup-r2.env".content = ''
      AWS_ACCESS_KEY_ID=${config.sops.placeholder."obsidian-backup/r2_access_key"}
      AWS_SECRET_ACCESS_KEY=${config.sops.placeholder."obsidian-backup/r2_secret_key"}
      AWS_REGION=auto
    '';
  };
}
