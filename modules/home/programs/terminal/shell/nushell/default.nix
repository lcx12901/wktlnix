{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.wktlnix.programs.terminal.shell.nushell;
in
{
  options.wktlnix.programs.terminal.shell.nushell = {
    enable = mkEnableOption "Whether or not to enable nushell.";
  };

  config = mkIf cfg.enable {
    programs = {
      nushell = {
        enable = true;

        shellAliases = lib.filterAttrs (_k: v: !lib.strings.hasInfix " && " v) config.home.shellAliases;
      };
    };
  };
}
