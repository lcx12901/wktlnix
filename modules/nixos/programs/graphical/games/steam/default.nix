{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (lib.wktlnix) enabled;

  persist = config.wktlnix.system.persist.enable;

  username = config.wktlnix.user.name;

  cfg = config.wktlnix.programs.graphical.games.steam;
in
{
  options.wktlnix.programs.graphical.games.steam = {
    enable = mkEnableOption "Whether or not to enable support for Steam.";
  };

  config = mkIf cfg.enable {
    environment.persistence."/persist" = mkIf persist {
      users."${username}" = {
        directories = [
          ".steam"
          ".local/share/Steam" # The default Steam install location
        ];
      };
    };

    programs.steam = {
      enable = true;

      extest.enable = true;

      # Whether to open ports in the firewall for Steam Remote Play
      remotePlay.openFirewall = false;

      extraCompatPackages = [ pkgs.proton-ge-bin ];
    };

    hardware = {
      steam-hardware = enabled;
      xone = enabled;
      xpadneo = enabled;
    };

    networking.firewall = {
      allowedUDPPorts = [
        # Warframe
        4950
        4955
      ];

      allowedTCPPortRanges = [
        # Warframe
        {
          from = 6695;
          to = 6699;
        }
      ];
    };
  };
}
