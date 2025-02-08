{
  osConfig,
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt enabled;

  cfg = config.${namespace}.programs.terminal.tools.direnv;

  persist = osConfig.${namespace}.system.persist.enable;
in
{
  options.${namespace}.programs.terminal.tools.direnv = {
    enable = mkBoolOpt false "Whether or not to enable direnv.";
  };

  config = mkIf cfg.enable {
    home.sessionVariables = {
      DIRENV_LOG_FORMAT = "";
    };

    programs.direnv = {
      enable = true;
      nix-direnv = enabled;
    };

    home.persistence = mkIf persist {
      "/persist/home/${config.${namespace}.user.name}" = {
        allowOther = true;
        directories = [ ".local/share/direnv" ];
      };
    };
  };
}
