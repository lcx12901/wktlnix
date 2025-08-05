{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib.${namespace}) enabled;
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

  networking.firewall.allowedTCPPorts = [
    15631
    15632

    # yukino_sing
    11473
  ];

  networking.firewall.allowedUDPPorts = [
    15631
    15632

    # yukino_sing
    11473
  ];

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
