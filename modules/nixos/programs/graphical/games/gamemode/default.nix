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
  ];
in
{
  options.${namespace}.programs.graphical.games.gamemode = {
    enable = mkBoolOpt false "Whether or not to enable gamemode.";
  };

  imports = with inputs.nix-gaming.nixosModules; [
    pipewireLowLatency
    platformOptimizations
  ];

  config = mkIf cfg.enable {
    programs.gamemode = {
      enable = true;
      settings = {
        general = {
          softrealtime = "auto";
          renice = 15;
        };
        gpu = {
          apply_gpu_optimisations = "accept-responsibility";
          gpu_device = 0;
          amd_performance_level = "high";
        };
        # custom = {
        #   start = startscript.outPath;
        #   end = endscript.outPath;
        # };
      };
    };

    # see https://github.com/fufexan/nix-gaming/#pipewire-low-latency
    services.pipewire.lowLatency.enable = true;
    programs.steam.platformOptimizations.enable = true;
  };
}
