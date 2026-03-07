{ lib, ... }:
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
    };

    security = {
      sudo-rs = enabled;
    };
  };

  services.qemuGuest.enable = true;

  networking = {
    interfaces."eth0" = {
      ipv4.addresses = [
        {
          address = "64.186.234.52";
          prefixLength = 32;
        }
      ];
      ipv6.addresses = [
        {
          address = "2605:52c0:2:143:be24:11ff:fe89:638b";
          prefixLength = 64;
        }
      ];
    };

    defaultGateway = {
      address = "193.41.250.250";
      interface = "eth0";
    };

    defaultGateway6 = {
      address = "fe80::cc65:edff:fe4d:f832";
      interface = "eth0";
    };

    nameservers = lib.mkForce [
      "1.1.1.1"
      "1.0.0.1"
    ];
  };

  systemd.network.links."10-eth0" = {
    matchConfig.PermanentMACAddress = "bc:24:11:89:63:8b";
    linkConfig = {
      Name = "eth0";
      AlternativeName = "enp6s18 ens18";
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
