{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.programs.terminal.shell.nushell;
in
{
  options.${namespace}.programs.terminal.shell.nushell = {
    enable = mkBoolOpt true "Whether or not to enable nushell.";
  };

  config = lib.mkIf cfg.enable {
    programs = {
      nushell = {
        enable = true;

        shellAliases = lib.filterAttrs (_k: v: !lib.strings.hasInfix " && " v) config.home.shellAliases;
      };
    };
  };
}
