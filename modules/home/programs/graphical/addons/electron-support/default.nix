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

  # TODO: electron unsupport `NIXOS_OZONE_WL = "1"`， and fcitx5 in electron

  config = mkIf cfg.enable {
    home.sessionVariables = {
      # NIXOS_OZONE_WL = "1";
    };

    xdg.configFile."electron-flags.conf".source = ./electron-flags.conf;
  };
}
