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
      nginx = enabled;
      metapi = enabled;
    };

    security = {
      sudo-rs = enabled;
      acme = enabled;
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
        15032
        15631

        # yukino_sing
        11473
      ];

      allowedUDPPorts = [
        15032
        15631

        # yukino_sing
        11473
      ];
    };
  };

  services = {
    qemuGuest = enabled;

    hermes-agent = {
      enable = true;

      addToSystemPackages = true;

      environmentFiles = [ config.sops.secrets."hermes_env".path ];

      settings = {
        toolsets = [ "all" ];
        memory = {
          memory_enabled = true;
          user_profile_enabled = true;
        };
        documents = {
          "SOUL.md" = ./hermes/documents/SOUL.md;
        };
        model = {
          provider = "minimax";
          default = "MiniMax-M2.7";
        };
      };
    };
  };

  environment.persistence."/persist" = {
    hideMounts = true;

    directories = [
      "/var/lib/hermes"
    ];
  };

  sops.secrets = {
    "milet_sing" = { };
    "hermes_env" = { };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
