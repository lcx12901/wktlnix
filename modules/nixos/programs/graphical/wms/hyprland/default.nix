{
  config,
  inputs,
  lib,
  pkgs,
  system,
  namespace,
  ...
}:
let
  inherit (lib)
    makeBinPath
    mkIf
    types
    ;
  inherit (lib.${namespace}) mkBoolOpt mkOpt enabled;
  inherit (inputs) hyprland;

  cfg = config.${namespace}.programs.graphical.wms.hyprland;

  programs = makeBinPath (
    with pkgs;
    [
      hyprland.packages.${system}.hyprland
      coreutils
      systemd
      libnotify
    ]
  );
in {
  options.${namespace}.programs.graphical.wms.hyprland = with types; {
    enable = mkBoolOpt false "Whether or not to enable Hyprland.";
    customConfigFiles =
      mkOpt attrs { }
        "Custom configuration files that can be used to override the default files.";
    customFiles = mkOpt attrs { } "Custom files that can be used to override the default files.";
  };

  disabledModules = [ "programs/hyprland.nix" ];

  config = mkIf cfg.enable {
    environment = {
      etc."greetd/environments".text = ''
        "Hyprland"
        fish
      '';
    };

    wktlnix = {
      display-managers = {
        sddm = enabled;
      };
    };

    services.displayManager.sessionPackages = [ hyprland.packages.${system}.hyprland ];
  };
}