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
        mainModel = "metapi/gpt-5.5";
        quickModel = "metapi/gpt-5.4";

        defaultSettings = {
          agents = {
            sisyphus = {
              model = mainModel;
            };
            oracle = {
              model = mainModel;
            };
            explore = {
              model = mainModel;
            };
            librarian = {
              model = mainModel;
            };
          };
          categories = {
            quick = {
              model = quickModel;
              description = "Fast, minimal edits and low-surface changes.";
            };
            deep = {
              model = mainModel;
            };
            unspecified-high = {
              model = mainModel;
              description = "General engineering work that benefits from stronger reasoning.";
            };
            unspecified-low = {
              model = mainModel;
              description = "Cheaper general subtasks and verification work.";
            };
            writing = {
              model = mainModel;
              description = "Documentation and prose-heavy tasks.";
            };
          };

          disabled_skills = [
            "frontend-ui-ux"
            "git-master"
            "playwright"
            "playwright-cli"
          ];

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
