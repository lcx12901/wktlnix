{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.programs.graphical.addons.electron-support;
in
{
  options.${namespace}.programs.graphical.addons.electron-support = {
    enable = mkBoolOpt false "Whether to enable wayland electron support in the desktop environment.";
  };

  config = mkIf cfg.enable {
    home.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      ELECTRON_OZONE_PLATFORM_HINT = "wayland";
    };

    xdg.configFile."electron-flags.conf".text = ''
      --enable-features=UseOzonePlatform,WaylandWindowDecorations
      --ozone-platform=wayland
      --ozone-platform-hint=wayland
    '';
  };
}
