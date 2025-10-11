{
  osConfig,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.wktlnix.programs.terminal.tools.nh;
in
{

  options.wktlnix.programs.terminal.tools.nh = {
    enable = mkEnableOption "Whether or not to enable nh.";
  };

  config = mkIf cfg.enable {
    programs.nh = {
      enable = true;

      clean = {
        enable = true;
      };

      flake = "${config.home.homeDirectory}/Coding/wktlnix";
    };

    launchd.agents.nh-clean.config = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
      StandardErrorPath = osConfig.khanelinix.programs.terminal.tools.nh.logPaths.stderr;
      StandardOutPath = osConfig.khanelinix.programs.terminal.tools.nh.logPaths.stdout;
    };

    home = {
      sessionVariables = {
        NH_SEARCH_PLATFORM = 1;
      };
      shellAliases = {
        nixre = "nh ${if pkgs.stdenv.hostPlatform.isLinux then "os" else "darwin"} switch";
      };
    };
  };
}
