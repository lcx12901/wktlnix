{
  osConfig,
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (lib.wktlnix) enabled;

  cfg = config.wktlnix.programs.terminal.tools.direnv;

  persist = osConfig.wktlnix.system.persist.enable;
in
{
  options.wktlnix.programs.terminal.tools.direnv = {
    enable = mkEnableOption "Whether or not to enable direnv.";
  };

  config = mkIf cfg.enable {
    programs.direnv = {
      enable = true;
      nix-direnv = enabled;
      silent = true;

      config = {
        global = {
          log_format = "-";
          log_filer = "^$";
        };
      };
    };

    home.persistence = mkIf persist {
      "/persist/home/${config.wktlnix.user.name}" = {
        allowOther = true;
        directories = [ ".local/share/direnv" ];
      };
    };
  };
}
