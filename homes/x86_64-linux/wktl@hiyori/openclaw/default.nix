{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.openclaw = {
    documents = null;

    excludeTools = [
      "git"
      "jq"
      "ripgrep"
      "curl"
      "nodejs_22"
    ];

    instances.default = {
      enable = true;

      config = {
        agents.defaults = {
          model = {
            primary = "metapi/gpt-5.5";
            fallbacks = [ "metapi/gpt-5.4" ];
          };
          models = {
            "metapi/gpt-5.5" = {
              alias = "GPT 5.5";
            };
            "metapi/gpt-5.4" = {
              alias = "GPT 5.4";
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
            (-5071044517)
          ];
          groups = {
            "*" = {
              requireMention = true;
            };
          };
        };

        models = {
          mode = "merge";
          providers.metapi = {
            api = "openai-completions";
            baseUrl = "https://metapi.milet.lincx.top/v1";
            apiKey = "\${METAPI_API_KEY}";
            models = [
              {
                id = "gpt-5.5";
                name = "GPT 5.5";
                input = [ "text" ];
              }
              {
                id = "gpt-5.4";
                name = "GPT 5.4";
                input = [ "text" ];
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
                apiKey = "\${METAPI_API_KEY}";
                model = "gpt-5.5";
                baseURL = "https://metapi.milet.lincx.top/v1";
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
      copyOpenClawDocuments = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        install -Dm0644 ${./documents}/AGENTS.md "$HOME/.openclaw/workspace/AGENTS.md"
        install -Dm0644 ${./documents}/SOUL.md "$HOME/.openclaw/workspace/SOUL.md"
        install -Dm0644 ${./documents}/IDENTITY.md "$HOME/.openclaw/workspace/IDENTITY.md"
        install -Dm0644 ${./documents}/TOOLS.md "$HOME/.openclaw/workspace/TOOLS.md"
      '';
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
