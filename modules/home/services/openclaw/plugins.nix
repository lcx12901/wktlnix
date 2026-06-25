{
  osConfig,
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.wktlnix.services.openclaw;
in
{
  config = lib.mkIf cfg.enable {
    programs.openclaw = {

      config.plugins = {
        # Load the locally-built Hindsight plugin (pnpm-format, so OpenClaw's
        # pnpm-workspace detection is satisfied and no source-checkout warning fires)
        load.paths = [
          "${pkgs.wktlnix.hindsight-openclaw}"
        ];

        # Plugin configuration
        entries.hindsight-openclaw = {
          enabled = true;
          config = {
            hindsightApiUrl = "https://hindsight.milet.lincx.top";
            # SecretRef: resolved at runtime via env var (wrapper reads sops file)
            hindsightApiToken = {
              source = "env";
              provider = "default";
              id = "HINDSIGHT_API_TOKEN";
            };

            # Memory isolation - use static bankId for OpenClaw
            bankId = "${osConfig.networking.hostName}-openclaw";

            # Auto-recall and auto-retain
            autoRecall = true;
            autoRetain = true;

            # Recall settings
            recallBudget = "high";
            recallMaxTokens = 4096;

            # Retention settings
            retainEveryNTurns = 5;
            retainOverlapTurns = 3;

            bankMission = "AI coding assistant working on NixOS infrastructure, web applications, and system tooling. Remember architecture decisions, debugging patterns, and project context.";
          };
        };
      };
    };
  };
}
