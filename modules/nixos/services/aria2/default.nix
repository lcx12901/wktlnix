{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.services.aria2;
in
{
  options.${namespace}.services.aria2 = {
    enable = lib.${namespace}.mkBoolOpt false "Whether or not to configure aria2.";
  };

  config = lib.mkIf cfg.enable {
    services.aria2 = {
      enable = true;
      openPorts = true;
      rpcSecretFile = config.age.secrets."aria2-rpc-token.text".path;
      settings = {
        # file setting
        disk-cache = "64M";
        file-allocation = "falloc";
        no-file-allocation-limit = "64M";
        continue = true;
        always-resume = true;
        max-resume-failure-tries = 0;
        remote-time = true;

        # speed setting
        input-file = "/var/lib/aria2/aria2.session";
        save-session = "/var/lib/aria2/aria2.session";
        save-session-interval = 1;
        auto-save-interval = 20;
        force-save = false;

        # download setting
        max-file-not-found = 10;
        max-tries = 0;
        retry-wait = 10;
        connect-timeout = 10;
        timeout = 10;
        max-connection-per-server = 16;
        split = 64;
        min-split-size = "4M";
        allow-piece-length-change = true;
        http-accept-gzip = true;
        reuse-uri = false;
        no-netrc = true;

        # BT setting
        enable-dht6 = true;
        dht-file-path = "/var/lib/aria2/dht.dat";
        dht-file-path6 = "/var/lib/aria2/dht6.dat";
        dht-entry-point = "dht.transmissionbt.com:6881";
        dht-entry-point6 = "dht.transmissionbt.com:6881";
        bt-enable-lpd = true;
        bt-max-peers = 128;
        bt-request-peer-speed-limit = "10M";
        seed-time = 0;
        bt-tracker-connect-timeout = 10;
        bt-tracker-timeout = 10;
        bt-save-metadata = true;
        bt-load-saved-metadata = true;
        bt-remove-unselected-file = true;
        bt-force-encryption = true;
        bt-detach-seed-only = true;
        user-agent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/93.0.4577.63 Safari/537.36 Edg/93.0.961.47";

        bt-tracker = lib.strings.concatStringsSep "," [
          "udp://tracker.opentrackr.org:1337/announce"
          "udp://open.demonii.com:1337/announce"
          "udp://open.stealth.si:80/announce"
          "udp://tracker.torrent.eu.org:451/announce"
          "udp://tracker-udp.gbitt.info:80/announce"
          "udp://explodie.org:6969/announce"
          "udp://exodus.desync.com:6969/announce"
          "udp://tracker.dump.cl:6969/announce"
          "udp://tracker.ccp.ovh:6969/announce"
          "udp://tracker.bittor.pw:1337/announce"
          "udp://tracker.0x7c0.com:6969/announce"
          "udp://run.publictracker.xyz:6969/announce"
          "udp://retracker01-msk-virt.corbina.net:80/announce"
          "udp://opentracker.io:6969/announce"
          "udp://open.free-tracker.ga:6969/announce"
          "udp://new-line.net:6969/announce"
          "udp://leet-tracker.moe:1337/announce"
          "udp://isk.richardsw.club:6969/announce"
          "https://tracker.tamersunion.org:443/announce"
          "http://tracker1.bt.moack.co.kr:80/announce"
        ];
      };
    };

    systemd.services.aria2.serviceConfig.ExecStartPre = [
      "${pkgs.coreutils}/bin/touch /var/lib/aria2/dht.dat"
      "${pkgs.coreutils}/bin/touch /var/lib/aria2/dht6.dat"
    ];
  };
}
