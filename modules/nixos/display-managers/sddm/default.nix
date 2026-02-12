{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (lib.wktlnix) enabled;

  cfg = config.wktlnix.display-managers.sddm;
in
{
  options.wktlnix.display-managers.sddm = {
    enable = mkEnableOption "Whether or not to enable sddm.";
  };

  config = mkIf cfg.enable {
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
          wayland = enabled;
        };
      };
    };
  };
}
