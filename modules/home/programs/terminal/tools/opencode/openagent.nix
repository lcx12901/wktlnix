{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.wktlnix.programs.terminal.tools.opencode;

  json = pkgs.formats.json { };
in
{
  config = lib.mkIf cfg.enable {
    xdg.configFile."opencode/oh-my-openagent.json".source =
      let
        defaultSettings = {
          git_master = {
            commit_footer = false;
            include_co_authored_by = false;
          };

          runtime_fallback = true;

          model_capabilities = {
            enabled = true;
            auto_refresh_on_start = true;
            refresh_timeout_ms = 5000;
          };
        };
      in
      json.generate "oh-my-openagent.json" defaultSettings;
  };
}
