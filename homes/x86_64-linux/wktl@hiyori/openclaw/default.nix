{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.openclaw = {
    documents = ./documents;

    instances = {
      default = {
        enable = true;

        config = {
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

          channels.telegram = {
            allowFrom = [
              975201632
              (-5281713495)
            ];
            groups = {
              "*" = {
                requireMention = true;
              };
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
                extractMinMessages = 2;
                extractMaxChars = 8000;

                llm = {
                  auth = "api-key";
                  apiKey = "\${MINIMAX_API_KEY}";
                  model = "MiniMax-M2.7";
                  baseURL = "https://api.minimax.io/anthropic/v1";
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

    # Excluded tools - these won't be available to the agent
    excludeTools = [
      "git"
      "jq"
      "ripgrep"
      "curl"
      "nodejs_22"
    ];

    bundledPlugins = {
      # Enable bundled plugins as needed
      # summarize.enable = true;
      # peekaboo.enable = true;
      # goplaces.enable = true;
    };

    customPlugins = [
      # Add custom plugins here
      # {
      #   source = "github:owner/repo?rev=<commit>&narHash=<narHash>";
      #   config = { ... };
      # }
    ];
  };

  systemd.user.services.openclaw-gateway = {
    Unit = {
      Wants = [ "sops-nix.service" ];
      After = [ "sops-nix.service" ];
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  home = {
    activation = {
      copyOpenClawMemoryPlugin = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        pluginDir="$HOME/.openclaw/plugins/memory-lancedb-pro"
        rm -rf "$pluginDir"
        mkdir -p "$pluginDir"
        cp -r --no-preserve=mode,ownership,timestamps,links ${pkgs.wktlnix.memory-lancedb-pro}/. "$pluginDir/"
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

  sops.secrets."openclaw_gateway_env" = {
    path = "${config.home.homeDirectory}/.openclaw/.env";
  };
}
