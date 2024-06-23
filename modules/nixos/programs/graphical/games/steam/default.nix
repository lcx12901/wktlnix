{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt enabled;

  persist = config.${namespace}.system.persist.enable;

  username = config.${namespace}.user.name;

  cfg = config.${namespace}.programs.graphical.games.steam;
in {
  options.${namespace}.programs.graphical.games.steam = {
    enable = mkBoolOpt false "Whether or not to enable support for Steam.";
  };

  config = mkIf cfg.enable {
    environment = {
      systemPackages = with pkgs; [steamtinkerlaunch];

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

      # fix gamescope inside steam
      package = pkgs.steam.override {
        extraPkgs = pkgs:
          with pkgs; [
            libgdiplus
            keyutils
            libkrb5
            libpng
            libpulseaudio
            libvorbis
            stdenv.cc.cc.lib
            xorg.libXcursor
            xorg.libXi
            xorg.libXinerama
            xorg.libXScrnSaver
            at-spi2-atk
            fmodex
            gtk3-x11
            harfbuzz
            icu
            glxinfo
            inetutils
            libthai
            mono5
            pango
            strace
            zlib

            # fix CJK fonts
            source-sans
            source-serif
            source-han-sans
            source-han-serif
          ];
      };

      # Whether to open ports in the firewall for Steam Remote Play
      remotePlay.openFirewall = false;

      # Whether to open ports in the firewall for Source Dedicated Server
      dedicatedServer.openFirewall = false;

      extraCompatPackages = [pkgs.proton-ge-bin.steamcompattool];
    };

    hardware = {
      steam-hardware = enabled;
      xone = enabled;
      xpadneo = enabled;
    };
  };
}
