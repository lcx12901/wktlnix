{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt enabled;

  persist = config.${namespace}.system.persist.enable;

  username = config.${namespace}.user.name;

  cfg = config.${namespace}.programs.graphical.games.steam;
in
{
  options.${namespace}.programs.graphical.games.steam = {
    enable = mkBoolOpt false "Whether or not to enable support for Steam.";
  };

  config = mkIf cfg.enable {
    environment = {
      # systemPackages = with pkgs; [ steamtinkerlaunch ];

      persistence."/persist" = mkIf persist {
        users."${username}" = {
          directories = [
            ".steam"
            ".local/share/Steam" # The default Steam install location
          ];
        };
      };
    };

    programs.steam = {
      enable = true;

      # https://github.com/ValveSoftware/gamescope
      gamescopeSession.enable = true;

      # fix gamescope inside steam
      package = pkgs.steam.override {
        extraPkgs =
          pkgs: with pkgs; [
            xorg.libXcursor
            xorg.libXi
            xorg.libXinerama
            xorg.libXScrnSaver
            libpng
            libpulseaudio
            libvorbis
            stdenv.cc.cc.lib
            libkrb5
            keyutils

            # fix CJK fonts
            source-sans
            source-serif
            source-han-sans
            source-han-serif

            # audio
            pipewire

            # other common
            udev
            alsa-lib
            vulkan-loader
            xorg.libX11
            xorg.libXcursor
            xorg.libXi
            xorg.libXrandr # To use the x11 feature
            libxkbcommon
            wayland # To use the wayland feature
          ];
      };

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
