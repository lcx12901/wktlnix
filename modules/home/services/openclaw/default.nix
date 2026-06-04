{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.wktlnix) mkBoolOpt mkOpt;
  cfg = config.wktlnix.services.openclaw;

  allSkills = import ./skills.nix { inherit pkgs; };
in
{
  options.wktlnix.services.openclaw = with lib.types; {
    enable = mkBoolOpt false "Whether to enable OpenClaw.";
    channels = mkOpt attrs { } "Channel configuration.";
  };

  imports = [
    ./agent-defaults.nix
    ./agent-list.nix
    ./models.nix
    ./plugins.nix
    ./browser-tools.nix
    ./bootstrap.nix
  ];

  config = lib.mkIf cfg.enable {
    programs.openclaw = {
      instances.default = {
        enable = true;

        runtimePackages = [ pkgs.chromium ];

        config = {
          inherit (cfg) channels;

          # Phase 1: enable cache trace diagnostics for 24h to analyze context bloat
          # TODO: set includeMessages/includePrompt/includeSystem to false after analysis
          diagnostics = {
            cacheTrace = {
              enabled = true;
              filePath = "/home/wktl/.openclaw/trajectory/cache-traces.jsonl";
              includeMessages = true;
              includePrompt = true;
              includeSystem = true;
            };
          };
        };
      };

      excludeTools = [
        "git"
        "jq"
        "ripgrep"
        "curl"
        "nodejs_22"
      ];
      bundledPlugins = { };
      customPlugins = [ ];

      skills = allSkills;
    };
  };
}
