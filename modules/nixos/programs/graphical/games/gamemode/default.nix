{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption getExe';

  cfg = config.wktlnix.programs.graphical.games.gamemode;

  defaultStartScript = ''
    ${getExe' pkgs.libnotify "notify-send"} 'GameMode started'
  '';

  defaultEndScript = ''
    ${getExe' pkgs.libnotify "notify-send"} 'GameMode ended'
  '';
in
{
  options.wktlnix.programs.graphical.games.gamemode = {
    enable = mkEnableOption "Whether or not to enable gamemode.";
  };

  imports = with inputs.nix-gaming.nixosModules; [
    pipewireLowLatency
    platformOptimizations
  ];

  config =
    let
      startScript = pkgs.writeShellScript "gamemode-start" defaultStartScript;
      endScript = pkgs.writeShellScript "gamemode-end" defaultEndScript;
    in
    mkIf cfg.enable {
      programs.gamemode = {
        enable = true;
        settings = {
          general = {
            renice = 10; # Nice game processes for better priority
            ioprio = 0; # Highest IO priority for game processes
            inhibit_screensaver = 1;
            disable_splitlock = 1; # Disable split-lock mitigation for performance
          };

          cpu = {
            park_cores = "no"; # Don't park cores
            pin_cores = "yes"; # Pin game to optimal cores (auto-detected)
          };

          gpu = {
            # AMD GPU optimization - switch to high performance level
            apply_gpu_optimisations = "accept-responsibility";
            gpu_device = 1; # AMD GPU is on card1
            amd_performance_level = "high";
          };

          custom = {
            start = startScript.outPath;
            end = endScript.outPath;
          };
        };
      };

      # Add user to gamemode group for renice and parking permissions
      wktlnix.user.extraGroups = [ "gamemode" ];

      security.wrappers.gamemode = {
        owner = "root";
        group = "root";
        source = "${lib.getExe' pkgs.gamemode "gamemoderun"}";
        capabilities = "cap_sys_ptrace,cap_sys_nice+pie";
      };

      # Allow reading CPU power consumption for gamemode monitoring
      systemd.tmpfiles.settings."10-gamemode-powercap" = {
        "/sys/devices/virtual/powercap/intel-rapl/intel-rapl:0/intel-rapl:0:0/energy_uj".z = {
          mode = "0644";
        };
      };

      boot.kernel.sysctl = {
        # default on some gaming (SteamOS) and desktop (Fedora) distributions
        # might help with gaming performance
        "vm.max_map_count" = 2147483642;
      };
    };
}
