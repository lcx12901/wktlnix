{
  osConfig,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    getExe
    getExe'
    ;

  persist = osConfig.wktlnix.system.persist.enable;

  cfg = config.wktlnix.programs.terminal.tools.omp;

  yaml = pkgs.formats.yaml { };

  modelsFile = yaml.generate "omp-models.yml" {
    providers.opencode-go.apiKey = "!cat ${config.sops.secrets."OPENCODE_API_KEY".path}";
  };

  configFile = yaml.generate "omp-config.yml" {
    modelRoles = {
      default = "opencode-go/mimo-v2.6-flash:xhigh";
      plan = "opencode-go/mimo-v2.6-flash:xhigh";
      slow = "opencode-go/mimo-v2.6-flash:xhigh";
      designer = "opencode-go/mimo-v2.6-flash:xhigh";
      smol = "opencode-go/mimo-v2.6-flash:xhigh";
      vision = "opencode-go/qwen3.5-plus:high";
    };
    setupVersion = 2;
    startup.quiet = true;
    theme = {
      dark = "dark-catppuccin";
    };
    symbolPreset = "nerd";
    colorBlindMode = true;
    statusLine = {
      preset = "nerd";
      separator = "ascii";
    };
    compaction = {
      enabled = true;
      reserveTokens = 32768;
      keepRecentTokens = 20000;
      autoContinue = true;
    };
    python.interpreter = "${getExe pkgs.python3}";
  };

  lspFile = yaml.generate "omp-models.yml" {
    servers = {
      nixd = {
        command = getExe pkgs.nixd;
        fileTypes = [ ".nix" ];
        rootMarkers = [
          "flake.nix"
          "default.nix"
          "shell.nix"
        ];
        initOptions = {
          formatting = {
            command = [ (lib.getExe pkgs.nixfmt) ];
          };
          options = {
            nixos = {
              expr = "(builtins.getFlake \"${config.home.homeDirectory}/Coding/wktlnix\").nixosConfigurations.kanroji.options";
            };
            home-manager = {
              expr = "(builtins.getFlake \"${config.home.homeDirectory}/Coding/wktlnix\").homeConfigurations.\"wktl@kanroji\".options";
            };
          };
        };
      };
      typescript = {
        command = getExe pkgs.typescript-language-server;
        args = [ "--stdio" ];
        fileTypes = [
          ".ts"
          ".tsx"
          ".js"
          ".jsx"
          ".mjs"
          ".cjs"
          ".mts"
          ".cts"
        ];
      };
      vue = {
        command = getExe pkgs.vue-language-server;
        args = [ "--stdio" ];
        fileTypes = [
          ".vue"
        ];
      };
      eslint = {
        command = getExe' pkgs.vscode-langservers-extracted "vscode-eslint-language-server";
        args = [ "--stdio" ];
        fileTypes = [
          ".js"
          ".jsx"
          ".ts"
          ".tsx"
          ".vue"
        ];
      };
      yaml-ls = {
        command = getExe pkgs.yaml-language-server;
        args = [ "--stdio" ];
        fileTypes = [
          ".yaml"
          ".yml"
        ];
      };
      jsonls = {
        command = getExe' pkgs.vscode-langservers-extracted "vscode-json-language-server";
        args = [ "--stdio" ];
        fileTypes = [
          ".json"
          ".jsonc"
        ];
      };
      bashls = {
        command = getExe pkgs.bash-language-server;
        args = [ "start" ];
        fileTypes = [
          ".sh"
          ".bash"
        ];
      };
      marksman = {
        command = getExe pkgs.marksman;
        fileTypes = [
          ".md"
          ".mdx"
        ];
      };
      rust-analyzer = {
        command = getExe pkgs.rust-analyzer;
        fileTypes = [ ".rs" ];
      };
    };
  };
in
{
  options.wktlnix.programs.terminal.tools.omp = {
    enable = mkEnableOption "omp";
  };

  config = mkIf cfg.enable {
    home = {
      packages = [ pkgs.llm-agents.omp ];

      activation = {
        ompConfig = {
          after = [ "writeBoundary" ];
          before = [ ];
          data = ''
            run mkdir -p "$HOME/.omp/agent"
            run install -m 600 ${configFile} "$HOME/.omp/agent/config.yml"
            run install -m 600 ${modelsFile} "$HOME/.omp/agent/models.yml"
            run install -m 600 ${lspFile} "$HOME/.omp/agent/lsp.yml"
            run install -m 600 ${./agent/RULES.md} "$HOME/.omp/RULES.md"
          '';
        };
      };

      persistence = lib.mkIf persist {
        "/persist" = {
          directories = [
            ".omp"
          ];
        };
      };
    };

    # Also declared by the opencode module; empty declarations merge.
    sops.secrets."OPENCODE_API_KEY" = { };

  };
}
