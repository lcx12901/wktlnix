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
      # Load the locally-built Hindsight plugin
      config.plugins.load.paths = [
        "${pkgs.wktlnix.hindsight-openclaw}"
      ];

      # Plugin configuration
      config.plugins.entries.hindsight-openclaw = {
        enabled = true;
        config = {
          hindsightApiUrl = "https://hindsight.milet.lincx.top";
          # Use environment variable (set in default.nix environment)
          hindsightApiToken = "{env:HINDSIGHT_API_TOKEN}";

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
}
