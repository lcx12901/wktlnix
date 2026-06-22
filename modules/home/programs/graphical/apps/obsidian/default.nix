{
  osConfig,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.wktlnix.programs.graphical.apps.obsidian;
  persist = osConfig.wktlnix.system.persist.enable;

  mainJs = pkgs.fetchurl {
    url = "https://github.com/vrtmrz/obsidian-livesync/releases/download/0.25.76/main.js";
    hash = "sha256-03xpvfrvxp7kwzcfnfia28i7jq5iaxmrq06jgpp543xn50s42qyc";
  };
  manifestJson = pkgs.fetchurl {
    url = "https://github.com/vrtmrz/obsidian-livesync/releases/download/0.25.76/manifest.json";
    hash = "sha256-1zvikw0aycghcxi912inqhklhkj9wzrvm6lbdadcrkc4sgdq7kza";
  };
  stylesCss = pkgs.fetchurl {
    url = "https://github.com/vrtmrz/obsidian-livesync/releases/download/0.25.76/styles.css";
    hash = "sha256-1wr7kjankqnw0cmrsfrcvz0imsi1h2p2lvcyjzm9fzkd32c1glrp";
  };

  livesyncPlugin = pkgs.stdenvNoCC.mkDerivation {
    pname = "obsidian-livesync";
    version = "0.25.76";
    dontBuild = true;
    installPhase = ''
      mkdir -p $out
      cp ${mainJs} $out/main.js
      cp ${manifestJson} $out/manifest.json
      cp ${stylesCss} $out/styles.css
    '';
  };
in
{
  options.wktlnix.programs.graphical.apps.obsidian = {
    enable = mkEnableOption "Obsidian";
  };

  config = mkIf cfg.enable {
    programs.obsidian = {
      enable = true;
      cli.enable = true;

      defaultSettings = {
        corePlugins = [
          {
            name = "sync";
            enable = false;
          }
        ];

        communityPlugins = [
          {
            pkg = livesyncPlugin;
          }
        ];

        extraFiles."plugins/obsidian-livesync/data.json" = {
          source = config.sops.templates."obsidian-livesync-data.json".path;
        };
      };
    };

    sops.templates."obsidian-livesync-data.json" = {
      content = builtins.toJSON {
        couchDB_URI = "https://obsidian.emilia.wktl.de";
        couchDB_USER = "admin";
        couchDB_PASSWORD = config.sops.placeholder."obsidian-livesync/adminpass";
        couchDB_DBNAME = "obsidian";
        isConfigured = true;
        liveSync = true;
        syncOnSave = true;
        syncOnStart = true;
        encrypt = false;
      };
    };

    sops.secrets."obsidian-livesync/adminpass" = {
      sopsFile = lib.file.get-file "secrets/obsidian.yaml";
    };

    home.persistence = lib.mkIf persist {
      "/persist" = {
        directories = [ ".config/obsidian" ];
      };
    };
  };
}
