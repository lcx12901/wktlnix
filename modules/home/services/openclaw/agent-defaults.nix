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

        # Tool results >4K chars are eligible for pruning
        minPrunableToolChars = 4000;
        # When context hits 70%+ budget, trim 30% oldest tool results
        hardClearRatio = 0.3;

        # Soft trim: cap each tool result in context
        softTrim = {
          maxChars = 8000;
          headChars = 2000;
          tailChars = 2000;
        };

        # Allow pruning tool results from output-heavy tools
        tools = {
          allow = [
            "exec"
            "web_fetch"
            "file_fetch"
          ];
        };
      };

      # Tighter compaction: recent context from 4K→2K, history share 60%→40%
      compaction = {
        mode = "safeguard";
        reserveTokens = 4000;
        keepRecentTokens = 2000;
        maxHistoryShare = 0.4;

        # Mid-turn context pressure detection
        midTurnPrecheck = {
          enabled = true;
        };
      };

      heartbeat = {
        every = "30m";
      };
    };
  };
}
