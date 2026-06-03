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

  allSkills = import ./skills.nix { inherit pkgs; };
  allSkillNames = map (s: s.name) allSkills;
in
{
  options.wktlnix.services.openclaw = with lib.types; {
    enable = mkBoolOpt false "Whether to enable OpenClaw.";
    channels = mkOpt attrs { } "Channel configuration.";
  };

  config = lib.mkIf cfg.enable {
    programs.openclaw = {
      instances = {
        default = {
          enable = true;

          runtimePackages = [ pkgs.chromium ];

          config = {
            inherit (cfg) channels;

            browser = {
              executablePath = "${pkgs.chromium}/bin/chromium";
              headless = true;
              noSandbox = true;
              extraArgs = [
                "--disable-gpu"
                "--disable-dev-shm-usage"
                "--no-zygote"
              ];
              tabCleanup = {
                enabled = true;
                idleMinutes = 30;
              };
            };

            tools.web.fetch.ssrfPolicy.allowRfc2544BenchmarkRange = true;
            tools.exec = {
              mode = "auto";
              strictInlineEval = true;
            };

            agents.defaults = {
              model = {
                primary = "minimax/MiniMax-M3";
                fallbacks = [
                  "minimax/MiniMax-M2.7"
                  "deepseek/deepseek-v4-flash"
                ];
              };
              models = {
                "minimax/MiniMax-M2.7" = {
                  alias = "MiniMax M2.7";
                };
                "minimax/MiniMax-M3" = {
                  alias = "MiniMax M3";
                };
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
                runTimeoutSeconds = 600;
                thinking = "medium";
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

              compaction = {
                mode = "safeguard";
                reserveTokens = 8000;
                keepRecentTokens = 4000;
                maxHistoryShare = 0.6;
              };

              heartbeat = {
                every = "30m";
              };
            };

            agents.list = [
              {
                id = "nova";
                skills = [
                  "self-improving-agent"
                  "multi-search-engine"
                  "sovereign-commit-craft"
                  "capability-evolver-pro"
                  "code-review"
                ];
              }
              {
                id = "evaluator";
                name = "质量评估专家";
                workspace = "${config.home.homeDirectory}/.openclaw/workspace/evaluator";
                skills = [
                  "code-review"
                  "self-improving-agent"
                ];
                model = {
                  primary = "deepseek/deepseek-v4-pro";
                };
              }
              {
                id = "researcher";
                name = "研究专家";
                workspace = "${config.home.homeDirectory}/.openclaw/workspace/researcher";
                skills = [
                  "multi-search-engine"
                  "self-improving-agent"
                ];
              }
              {
                id = "frontend-dev";
                name = "前端开发专家";
                workspace = "${config.home.homeDirectory}/.openclaw/workspace/frontend-dev";
                skills = [
                  "vue"
                  "vite"
                  "vitest"
                  "pinia"
                  "unocss"
                  "vue-best-practices"
                  "vue-testing-best-practices"
                  "leaferjs"
                  "multi-search-engine"
                  "self-improving-agent"
                ];
                model = {
                  primary = "deepseek/deepseek-v4-flash";
                };
              }
              {
                id = "backend-dev";
                name = "后端开发专家";
                workspace = "${config.home.homeDirectory}/.openclaw/workspace/backend-dev";
                skills = [
                  "multi-search-engine"
                  "self-improving-agent"
                  "code-review"
                ];
                model = {
                  primary = "deepseek/deepseek-v4-flash";
                };
              }
              {
                id = "product-manager";
                name = "产品经理专家";
                workspace = "${config.home.homeDirectory}/.openclaw/workspace/product-manager";
                skills = [
                  "user-story-mapping"
                  "roadmap-planning"
                  "user-story-splitting"
                  "discovery-process"
                  "prd-development"
                  "prioritization-advisor"
                  "company-research"
                  "multi-search-engine"
                  "self-improving-agent"
                ];
              }
              {
                id = "ui-designer";
                name = "UI 设计专家";
                workspace = "${config.home.homeDirectory}/.openclaw/workspace/ui-designer";
                skills = [
                  "ui-ux-pro-max"
                  "design-system"
                  "design"
                  "banner-design"
                  "brand"
                  "slides"
                  "ui-styling"
                  "design-review"
                  "react"
                  "tailwindcss"
                  "shadcn-ui"
                  "responsive-design"
                  "a11y"
                  "multi-search-engine"
                  "self-improving-agent"
                ];
                model = {
                  primary = "deepseek/deepseek-v4-flash";
                };
              }
            ];

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
              reset = {
                mode = "idle";
                idleMinutes = 240;
              };
            };

            diagnostics = {
              cacheTrace = {
                enabled = true;
                filePath = "${config.home.homeDirectory}/.openclaw/trajectory/cache-traces.jsonl";
                includeMessages = false;
                includePrompt = false;
                includeSystem = false;
              };
            };

            models = {
              mode = "merge";
              providers = {
                minimax = {
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
                        input = 0;
                        output = 0;
                        cacheRead = 0;
                        cacheWrite = 0;
                      };
                    }
                    {
                      id = "MiniMax-M3";
                      name = "MiniMax M3";
                      reasoning = true;
                      input = [ "text" ];
                      contextWindow = 1000000;
                      maxTokens = 32000;
                      cost = {
                        input = 0;
                        output = 0;
                        cacheRead = 0;
                        cacheWrite = 0;
                      };
                    }
                  ];
                };
                deepseek = {
                  api = "openai-completions";
                  baseUrl = "https://api.deepseek.com/v1";
                  apiKey = "\${DEEPSEEK_API_KEY}";
                  models = [
                    {
                      id = "deepseek-v4-flash";
                      name = "DeepSeek V4 Flash";
                      input = [ "text" ];
                      contextWindow = 1000000;
                      maxTokens = 128000;
                      cost = {
                        input = 0.14;
                        output = 0.28;
                        cacheRead = 0.0028;
                        cacheWrite = 0;
                      };
                    }
                    {
                      id = "deepseek-v4-pro";
                      name = "DeepSeek V4 Pro";
                      input = [ "text" ];
                      contextWindow = 1000000;
                      maxTokens = 384000;
                      cost = {
                        input = 0.435;
                        output = 0.87;
                        cacheRead = 0.0145;
                        cacheWrite = 0;
                      };
                    }
                  ];
                };
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
                  enableManagementTools = true;
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
                    apiKey = "\${DEEPSEEK_API_KEY}";
                    model = "deepseek-v4-flash";
                    baseURL = "https://api.deepseek.com/v1";
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

      skills = allSkills;
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
        cleanStaleLockFiles = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          find "$HOME/.openclaw/memory/lancedb-pro" -name ".memory-write.lock" -mmin +60 -delete 2>/dev/null || true
        '';
        setupTrajectoryDir = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          mkdir -p "$HOME/.openclaw/trajectory"
          # Archive cache-traces > 7 days to old/, keep at most 100 MB recent
          traj="$HOME/.openclaw/trajectory"
          if [ -f "$traj/cache-traces.jsonl" ] && [ "$(wc -c < "$traj/cache-traces.jsonl" 2>/dev/null || echo 0)" -gt 104857600 ]; then
            mkdir -p "$traj/old"
            ts=$(stat -c %Y "$traj/cache-traces.jsonl" 2>/dev/null || echo "$(date +%s)")
            mv "$traj/cache-traces.jsonl" "$traj/old/cache-traces-$ts.jsonl"
          fi
          # Prune old/ archives > 90 days
          find "$traj/old" -name "*.jsonl" -mtime +90 -delete 2>/dev/null || true
        '';
        copyAgentDocuments =
          lib.hm.dag.entryAfter [ "writeBoundary" ] # bash
            ''
              # Backup runtime PROGRESS.md if it has real user content
              # (size > 200 bytes means user has appended history beyond the template)
              runtime_progress="$HOME/.openclaw/workspace/PROGRESS.md"
              preserve_progress=0
              if [ -f "$runtime_progress" ] && [ "$(wc -c < "$runtime_progress")" -gt 200 ]; then
                cp "$runtime_progress" "$runtime_progress.runtime-bak-$$"
                preserve_progress=1
              fi

              # Copy nova documents directly to workspace root
              mkdir -p "$HOME/.openclaw/workspace"
              cp -r --no-preserve=mode,ownership,timestamps,links ${./documents}/nova/. "$HOME/.openclaw/workspace/"

              # Restore runtime PROGRESS.md if we backed it up
              if [ "$preserve_progress" = "1" ]; then
                mv "$runtime_progress.runtime-bak-$$" "$runtime_progress"
              fi

              # Copy other agent documents to their respective workspace subdirectories
              for agent_dir in ${./documents}/*/; do
                agent_name=$(basename "$agent_dir")
                if [ "$agent_name" != "nova" ]; then
                  mkdir -p "$HOME/.openclaw/workspace/$agent_name"
                  cp -r --no-preserve=mode,ownership,timestamps,links "$agent_dir/." "$HOME/.openclaw/workspace/$agent_name/"
                fi
              done
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
