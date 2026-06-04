{
  config,
  lib,
  ...
}:
let
  cfg = config.wktlnix.services.openclaw;
in
{
  config = lib.mkIf cfg.enable {
    programs.openclaw.instances.default.config.agents.defaults = {
      contextInjection = "continuation-skip";
      bootstrapMaxChars = 12000;
      bootstrapTotalMaxChars = 35000;

      model = {
        primary = "deepseek/deepseek-v4-flash";
        fallbacks = [
          "deepseek/deepseek-v4-pro"
        ];
      };
      models = {
        "deepseek/deepseek-v4-flash" = {
          alias = "DeepSeek V4 Flash";
        };
        "deepseek/deepseek-v4-pro" = {
          alias = "DeepSeek V4 Pro";
        };
      };
      subagents = {
        maxConcurrent = 8;
        maxSpawnDepth = 2;
        maxChildrenPerAgent = 5;
        runTimeoutSeconds = 300;
        thinking = "low";
        allowAgents = [
          "researcher"
          "frontend-dev"
          "backend-dev"
          "product-manager"
          "ui-designer"
          "evaluator"
        ];
      };

      contextPruning = {
        mode = "cache-ttl";
        ttl = "1h";
      };

      # Tighter compaction: recent context from 4K→2K, history share 60%→40%
      compaction = {
        mode = "safeguard";
        reserveTokens = 4000;
        keepRecentTokens = 2000;
        maxHistoryShare = 0.4;
      };

      heartbeat = {
        every = "30m";
      };
    };
  };
}
