{
  inputs,
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt enabled;

  cfg = config.${namespace}.display-managers.sddm;
in
{
  options.${namespace}.display-managers.sddm = {
    enable = mkBoolOpt false "Whether or not to enable sddm.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      (catppuccin-sddm.override {
        flavor = "macchiato";
        font = "Maple Mono NF CN";
        fontSize = "9";
        background = "${inputs.wallpapers}/wallhaven-x6em53.png";
        loginBackground = true;
      })

      kdePackages.sddm
    ];

    services = {
      displayManager = {
        sddm = {
          inherit (cfg) enable;
          theme = "catppuccin-macchiato";
          wayland = enabled;
        };
      };
    };
  };
}
