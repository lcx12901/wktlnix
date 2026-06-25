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
    programs.openclaw.config = {
      models = {
        mode = "merge";
        providers = {
          opencode-go = {
            api = "openai-completions";
            baseUrl = "https://opencode.ai/zen/go/v1";
            # SecretRef: resolved at runtime via env var (wrapper reads sops file)
            apiKey = {
              source = "env";
              provider = "default";
              id = "OPENCODE_API_KEY";
            };
            models = [
              {
                id = "mimo-v2.5";
                name = "MiMo V2.5";
                contextWindow = 1000000;
                maxTokens = 128000;
              }
            ];
          };
          opencode-go-anthropic = {
            api = "anthropic-messages";
            baseUrl = "https://opencode.ai/zen/go/v1";
            # SecretRef: resolved at runtime via env var (wrapper reads sops file)
            apiKey = {
              source = "env";
              provider = "default";
              id = "OPENCODE_API_KEY";
            };
            models = [
              {
                id = "minimax-m3";
                name = "MiniMax M3";
                input = [
                  "text"
                  "image"
                ];
                contextWindow = 512000;
                maxTokens = 131072;
              }
            ];
          };
        };
      };
      agents.defaults = {
        contextInjection = "continuation-skip";
        bootstrapMaxChars = 12000;
        bootstrapTotalMaxChars = 35000;

        model = {
          primary = "opencode-go/mimo-v2.5";
          fallbacks = [
            "opencode-go-anthropic/minimax-m3"
          ];
        };
        # subagents = {
        #   maxConcurrent = 8;
        #   maxSpawnDepth = 2;
        #   maxChildrenPerAgent = 5;
        #   runTimeoutSeconds = 300;
        #   thinking = "low";
        #   allowAgents = [];
        # };

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
  };
}
