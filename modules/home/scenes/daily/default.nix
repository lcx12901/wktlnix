{
  config,
  osConfig,
  lib,
  pkgs,
  inputs,
  namespace,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  persist = osConfig.${namespace}.system.persist.enable;

  cfg = config.${namespace}.scenes.daily;
in
{
  options.${namespace}.scenes.daily = {
    enable = mkBoolOpt false "Whether or not to enable daily configuration.";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.wechat-uos
      inputs.ayugram-desktop.packages.${pkgs.system}.ayugram-desktop
    ];

    home.persistence = mkIf persist {
      "/persist/home/${config.${namespace}.user.name}" = {
        directories = [ ".local/share/AyuGramDesktop" ];
      };
    };
  };
}
