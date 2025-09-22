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
            softrealtime = "auto";
            renice = 15;
          };
          # gpu = {
          #   apply_gpu_optimisations = "accept-responsibility";
          #   gpu_device = 0;
          #   amd_performance_level = "high";
          # };
          custom = {
            start = startScript.outPath;
            end = endScript.outPath;
          };
        };
      };

      security.wrappers.gamemode = {
        owner = "root";
        group = "root";
        source = "${lib.getExe' pkgs.gamemode "gamemoderun"}";
        capabilities = "cap_sys_ptrace,cap_sys_nice+pie";
      };

      boot.kernel.sysctl = {
        # default on some gaming (SteamOS) and desktop (Fedora) distributions
        # might help with gaming performance
        "vm.max_map_count" = 2147483642;
      };

      # see https://github.com/fufexan/nix-gaming/#pipewire-low-latency
      # services.pipewire.lowLatency.enable = true;
      # programs.steam.platformOptimizations.enable = true;
    };
}
