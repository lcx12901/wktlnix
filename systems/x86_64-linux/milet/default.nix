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
        device = "/dev/sda";
      };
      fonts = enabled;
      locale = {
        enable = true;
      };
      time = enabled;
      persist = enabled;
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
        configFile = config.sops.secrets."milet_sing".path;
      };
      frp = {
        enable = true;
        role = "server";
      };
    };

    security = {
      sudo-rs = enabled;
    };
  };
  networking = {
    # 6in4
    interfaces.ipv6net = {
      ipv4.addresses = [
        {
          address = "144.34.237.105";
          prefixLength = 22;
        }
      ];
      ipv6.addresses = [
        {
          address = "2607:8700:5500:b580::2";
          prefixLength = 64;
        }
      ];
    };
    sits.ipv6net = {
      local = "144.34.237.105";
      remote = "45.32.66.87";
      ttl = 255;
    };
    defaultGateway6 = {
      address = "2607:8700:5500:b580::1";
      interface = "ipv6net";
    };

    firewall = {
      allowedTCPPorts = [
        15631
        15632

        # yukino_sing
        11473
      ];

      allowedUDPPorts = [
        15631
        15632

        # yukino_sing
        11473
      ];
    };
  };

  sops.secrets = {
    "milet_sing" = { };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
