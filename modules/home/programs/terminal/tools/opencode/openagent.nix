{ config, lib, ... }:
let
  cfg = config.wktlnix.programs.terminal.tools.opencode;
in
{
  home.file = lib.mkIf cfg.enable {
    ".opencode/oh-my-openagent.json".text = builtins.toJSON {
      "$schema" =
        "https://raw.githubusercontent.com/code-yeongyu/oh-my-openagent/refs/heads/dev/assets/oh-my-opencode.schema.json";
      git_master = {
        include_co_authored_by = false;
      };
    };
  };
}
