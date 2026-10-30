{ config, lib, ... }:
let
  inherit (lib.wktlnix) enabled;
in
{
  imports = [ ./hardware.nix ];

  wktlnix = {
    system = {
      boot = enabled;
      disko = {
        enable = true;
        device = "/dev/vda";
      };
      fonts = enabled;
      locale = {
        enable = true;
      };
      time = enabled;
      persist = enabled;
      networking = {
        enable = true;
        optimizeTcp = true;
      };
    };

    hardware = {
      btrfs = enabled;
    };

    programs = {
      terminal.tools.nix-ld = enabled;
    };

    suites = {
      common = enabled;
    };

    services = {
      openssh = enabled;
      sing-box = {
        enable = true;
        configFile = config.sops.secrets."dmit_sing".path;
      };
    };

    security = {
      sudo-rs = enabled;
      acme = enabled;
    };
  };

  services.qemuGuest.enable = true;

  networking = {
    domain = lib.mkForce "wktl.de";

    interfaces."eth0" = {
      ipv4.addresses = [
        {
          address = "179.253.236.204";
          prefixLength = 32;
        }
      ];
      ipv6.addresses = [
        {
          address = "2605:52c0:2:143:be24:11ff:fe54:3c56";
          prefixLength = 64;
        }
      ];
    };

    defaultGateway = {
      address = "193.41.250.250";
      interface = "eth0";
    };

    defaultGateway6 = {
      address = "fe80::7020:59ff:fe4d:6416";
      interface = "eth0";
    };

    nameservers = lib.mkForce [
      "1.1.1.1"
      "1.0.0.1"
    ];

    firewall = {
      allowedTCPPorts = [
        51430
      ];

      allowedUDPPorts = [
        51430
        47508
      ];
    };

    nftables = {
      enable = true;
      tables.hysteria-port-hop = {
        family = "inet";
        content = ''
          chain prerouting {
            type nat hook prerouting priority dstnat; policy accept;
            iifname "eth0" udp dport 30000-40000 counter redirect to :47508
          }
        '';
      };
    };
  };

  systemd.network.links."10-eth0" = {
    matchConfig.PermanentMACAddress = "bc:24:11:89:63:8b";
    linkConfig = {
      Name = "eth0";
      AlternativeName = "enp6s18 ens18";
    };
  };

  sops.secrets = {
    "dmit_sing" = { };
  };

  # reload sing-box after cert renewal
  security.acme.certs."dmit.wktl.de".reloadServices = [ "sing-box" ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05"; # Did you read the comment?
}
