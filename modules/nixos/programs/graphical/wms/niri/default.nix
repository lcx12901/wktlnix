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

  cfg = config.${namespace}.programs.graphical.wms.niri;
in
{
  options.${namespace}.programs.graphical.wms.niri = {
    enable = mkBoolOpt false "Whether or not to enable niri.";
  };

  config = mkIf cfg.enable {
    programs.niri = {
      enable = true;
      package = pkgs.niri-unstable;
    };

    wktlnix = {
      display-managers = {
        sddm = enabled;
      };

      services = {
        dbus = enabled;
        flatpak = {
          enable = true;
          extraPackages = [
            {
              appId = "cn.feishu.Feishu";
              origin = "flathub";
            }
          ];
        };
      };
      theme.stylix = enabled;
    };

    services.xserver = enabled;

    services = {
      # needed for GNOME services outside of GNOME Desktop
      udev.packages = with pkgs; [ gnome-settings-daemon ];
    };
  };
}
