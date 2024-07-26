{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.programs.terminal.tools.ssh;
in {
  options.${namespace}.programs.terminal.tools.ssh = {
    enable = mkBoolOpt true "Whether or not to enable ssh.";
  };

  config = mkIf cfg.enable {
    programs.ssh = {
      enable = true;
    };
  };
}
