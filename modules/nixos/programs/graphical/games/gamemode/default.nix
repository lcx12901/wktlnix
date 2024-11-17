{
  config,
  inputs,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkIf makeBinPath;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.programs.graphical.games.gamemode;

  programs = makeBinPath [
    inputs.hyprland.packages.${pkgs.stdenv.system}.default
    pkgs.coreutils
    pkgs.power-profiles-daemon
    pkgs.systemd
    pkgs.libnotify
  ];

  startscript = pkgs.writeShellScript "gamemode-start" ''
    export PATH=$PATH:${programs}
    export HYPRLAND_INSTANCE_SIGNATURE=$(ls -w1 /tmp/hypr | tail -1)
    hyprctl --batch 'keyword decoration:blur 0 ; keyword animations:enabled 0 ; keyword misc:vfr 0'

    powerprofilesctl set performance
    notify-send -a 'Gamemode' 'Optimizations activated' -u 'low'
  '';

  endscript = pkgs.writeShellScript "gamemode-end" ''
    export PATH=$PATH:${programs}
    export HYPRLAND_INSTANCE_SIGNATURE=$(ls -w1 /tmp/hypr | tail -1)
    hyprctl --batch 'keyword decoration:blur 1 ; keyword animations:enabled 1 ; keyword misc:vfr 1'

    powerprofilesctl set balanced
    notify-send -a 'Gamemode' 'Optimizations deactivated' -u 'low'
  '';
in
{
  options.${namespace}.programs.graphical.games.gamemode = {
    enable = mkBoolOpt false "Whether or not to enable gamemode.";
  };

  config = mkIf cfg.enable {
    programs.gamemode = {
      enable = true;
      enableRenice = true;
      settings = {
        general = {
          softrealtime = "auto";
          renice = 15;
        };

        custom = {
          start = startscript.outPath;
          end = endscript.outPath;
        };
      };
    };

    security.wrappers.gamemode = {
      owner = "root";
      group = "root";
      source = "${pkgs.gamemode}/bin/gamemoderun";
      capabilities = "cap_sys_ptrace,cap_sys_nice+pie";
    };

    boot.kernel.sysctl = {
      # default on some gaming (SteamOS) and desktop (Fedora) distributions
      # might help with gaming performance
      "vm.max_map_count" = 2147483642;
    };
  };
}
