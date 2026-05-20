{
  osConfig,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.wktlnix) mkBoolOpt mkOpt;
  cfg = config.wktlnix.services.openclaw;
in
{
  options.wktlnix.services.openclaw = with lib.types; {
    enable = mkBoolOpt false "Whether to enable OpenClaw.";
    channels = mkOpt attrs { } "Channel configuration.";
  };

  config = lib.mkIf cfg.enable {
    programs.openclaw = {
      documents = ./documents;

      instances = {
        default = {
          enable = true;

          config = {
            inherit (cfg) channels;

            agents.defaults = {
              model = {
                primary = "minimax/MiniMax-M2.7";
                fallbacks = [ "minimax/MiniMax-M2.5" ];
              };
              models = {
                "minimax/MiniMax-M2.7" = {
                  alias = "MiniMax M2.7";
                };
                "minimax/MiniMax-M2.5" = {
                  alias = "MiniMax M2.5";
                };
              };
            };

            gateway = {
              mode = "local";
              auth = {
                token = "\${OPENCLAW_GATEWAY_TOKEN}";
              };
            };

            session = {
              maintenance = {
                mode = "enforce";
                pruneAfter = "30d";
              };
            };

            models = {
              mode = "merge";
              providers.minimax = {
                api = "anthropic-messages";
                baseUrl = "https://api.minimax.io/anthropic/v1";
                apiKey = "\${MINIMAX_API_KEY}";
                models = [
                  {
                    id = "MiniMax-M2.7";
                    name = "MiniMax M2.7";
                    reasoning = true;
                    input = [ "text" ];
                    contextWindow = 200000;
                    maxTokens = 8192;
                    cost = {
                      input = 0.3;
                      output = 1.2;
                      cacheRead = 0.03;
                      cacheWrite = 0.12;
                    };
                  }
                  {
                    id = "MiniMax-M2.5";
                    name = "MiniMax M2.5";
                    reasoning = true;
                    input = [ "text" ];
                    contextWindow = 200000;
                    maxTokens = 8192;
                    cost = {
                      input = 0.3;
                      output = 1.2;
                      cacheRead = 0.03;
                      cacheWrite = 0.12;
                    };
                  }
                ];
              };
            };

            plugins = {
              enabled = true;
              load.paths = [ "${config.home.homeDirectory}/.openclaw/plugins/memory-lancedb-pro" ];
              slots.memory = "memory-lancedb-pro";
              entries."memory-lancedb-pro" = {
                enabled = true;
                hooks.allowConversationAccess = true;
                config = {
                  embedding = {
                    provider = "openai-compatible";
                    apiKey = "ollama";
                    model = "nomic-embed-text";
                    baseURL = "http://127.0.0.1:11434/v1";
                    dimensions = 768;
                  };
                  autoCapture = true;
                  autoRecall = true;
                  smartExtraction = true;
                  extractMinMessages = 6;
                  autoRecallMinLength = 50;
                  autoRecallMinRepeated = 20;
                  recallMode = "adaptive";
                  workspaceBoundary.userMdExclusive = {
                    enabled = true;
                    filterRecall = true;
                  };
                  sessionCompression = {
                    enabled = true;
                    minScoreToKeep = 0.4;
                  };
                  memoryCompaction = {
                    enabled = true;
                    minAgeDays = 7;
                    similarityThreshold = 0.92;
                    cooldownHours = 24;
                  };
                  selfImprovement = {
                    skipSubagentBootstrap = true;
                    ensureLearningFiles = true;
                  };
                  extractMaxChars = 8000;
                  llm = {
                    auth = "api-key";
                    apiKey = "\${MINIMAX_API_KEY}";
                    model = "MiniMax-M2.7";
                    baseURL = "https://api.minimax.io";
                    timeoutMs = 30000;
                  };
                  retrieval = {
                    mode = "hybrid";
                    rerank = "cross-encoder";
                    rerankProvider = "siliconflow";
                    rerankApiKey = "\${SILICONFLOW_API_KEY}";
                    rerankModel = "BAAI/bge-reranker-v2-m3";
                    rerankEndpoint = "https://api.siliconflow.cn/v1/rerank";
                    rerankTimeoutMs = 30000;
                    hardMinScore = 0.5;
                  };
                  sessionMemory = {
                    enabled = false;
                  };
                };
              };
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

      skills = import ./skills.nix { inherit pkgs; };
    };

    systemd.user.services.openclaw-gateway = {
      Service = {
        StandardOutput = lib.mkForce "journal";
        StandardError = lib.mkForce "journal";
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
    };

    home = {
      activation = {
        copyOpenClawMemoryPlugin = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          mkdir -p "$HOME/.openclaw/plugins"
          pluginDir="$HOME/.openclaw/plugins/memory-lancedb-pro"
          rm -rf "$pluginDir"
          cp -r --no-preserve=mode,ownership,timestamps,links ${pkgs.wktlnix.memory-lancedb-pro}/. "$pluginDir/"
        '';
        copyOpenClawAvatar = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          mkdir -p "$HOME/.openclaw/workspace/avatar"
          cp -r --no-preserve=mode,ownership,timestamps,links ${./avatar}/. "$HOME/.openclaw/workspace/avatar/"
        '';
        copySubAgentPolicy = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          cp -r --no-preserve=mode,ownership,timestamps,links ${./documents}/SUBAGENT-POLICY.md "$HOME/.openclaw/workspace/SUBAGENT-POLICY.md"
        '';
        cleanStaleLockFiles = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          find "$HOME/.openclaw/memory/lancedb-pro" -name ".memory-write.lock" -mmin +60 -delete 2>/dev/null || true
        '';
        ensureSelfImprovementReminder = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          touch "$HOME/.openclaw/workspace/SELF_IMPROVEMENT_REMINDER.md"
        '';
      };
      persistence = {
        "/persist" = {
          directories = [
            {
              directory = ".openclaw";
              mode = "0700";
            }
          ];
        };
      };
    };

    sops.secrets."${osConfig.networking.hostName}_openclaw_gateway_env" = {
      path = "${config.home.homeDirectory}/.openclaw/.env";
    };
  };
}
