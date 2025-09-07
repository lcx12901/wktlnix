{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.display-managers.sddm;
in
{
  options.${namespace}.display-managers.sddm = {
    enable = lib.mkEnableOption "Whether or not to enable sddm.";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      (sddm-astronaut.override {
        embeddedTheme = "hyprland_kath";
      })
    ];

    services = {
      displayManager = {
        sddm = {
          inherit (cfg) enable;
          package = pkgs.kdePackages.sddm;
          extraPackages = with pkgs.kdePackages; [ qtmultimedia ];
          theme = "sddm-astronaut-theme";
        };
      };
    };
  };
}
