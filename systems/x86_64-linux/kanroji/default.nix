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
      boot = {
        enable = true;
        useOSProber = true;
      };
      disko = {
        enable = true;
        device = "/dev/nvme0n1";
        rootSize = "1T";
      };
      fonts = enabled;
      locale = {
        enable = true;
      };
      time = enabled;
      persist = enabled;
      networking = {
        enable = true;
        wireless = true;
      };
    };

    hardware = {
      audio = enabled;
      graphics = enabled;
      cpu.intel = enabled;
      gpu.amd = enabled;
      btrfs = enabled;
    };

    programs = {
      graphical = {
        wms.niri = enabled;
        games = {
          steam = enabled;
          gamemode = enabled;
        };
        file-managers.nautilus = enabled;
      };
      terminal.tools.nix-ld = enabled;
    };

    suites = {
      common = enabled;
    };

    theme.stylix.image = "girls.jpg";

    services = {
      dae = {
        enable = true;
        extraNodes = config.sops.placeholder."yukino_dae_node";
        extraGroups = ''
          z9yun {
            policy: random
            filter: name(yukino)
          }
        '';
        extraRules = ''
          dip(192.168.0.0/24) -> z9yun
        '';
      };
      openssh = enabled;
      avahi = enabled;
    };

    security = {
      sudo-rs = enabled;
    };
  };

  sops.secrets."yukino_dae_node" = { };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
