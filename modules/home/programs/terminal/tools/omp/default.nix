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
    ;

  persist = osConfig.wktlnix.system.persist.enable;

  cfg = config.wktlnix.programs.terminal.tools.omp;

  yaml = pkgs.formats.yaml { };

  modelsFile = yaml.generate "omp-models.yml" {
    providers.opencode-go.apiKey = "!cat ${config.sops.secrets."OPENCODE_API_KEY".path}";
  };

  configFile = import ./config.nix { inherit lib pkgs; };
  lspFile = import ./lsp.nix { inherit config lib pkgs; };
  mcpFile = import ./mcp.nix { inherit config lib pkgs; };
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
            run install -m 600 ${mcpFile} "$HOME/.omp/agent/mcp.json"
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

    # providers.opencode-go 的 apiKey，models.yml 用 !cat 读取
    sops.secrets."OPENCODE_API_KEY" = { };
  };
}
