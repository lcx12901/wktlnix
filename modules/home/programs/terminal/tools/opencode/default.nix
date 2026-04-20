{
  inputs,
  osConfig,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  persist = osConfig.wktlnix.system.persist.enable;

  cfg = config.wktlnix.programs.terminal.tools.opencode;

  agents = import ./agents.nix { inherit lib; };
  commands = import ./commands.nix { inherit lib; };
  # Import curated skills (local bundle of skill packages)
  skillsPkg = import ./skills.nix { inherit inputs pkgs; };
in
{
  imports = [
    ./lsp.nix
    ./formatters.nix
    ./permission.nix
    ./openagent.nix
  ];

  options.wktlnix.programs.terminal.tools.opencode = {
    enable = mkEnableOption "opencode";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ lsof ];

    programs = {
      opencode = {
        enable = true;

        enableMcpIntegration = false;

        tui = {
          theme = "catppuccin-frappe";
        };

        settings = {
          model = "metapi/gpt-5.4";
          autoshare = false;
          autoupdate = false;

          plugin = [
            "@tarquinen/opencode-dcp@latest"
            "opencode-pty"
            "oh-my-openagent"
          ];

          provider = {
            metapi = {
              npm = "@ai-sdk/openai-compatible";
              name = "metapi";
              options = {
                baseURL = "https://metapi.milet.lincx.top/v1";
                apiKey = "{file:${config.sops.secrets."metapi_key".path}}";
              };
              models = {
                "gpt-5.4" ={
                  name = "GPT-5.4";
                  limit = {
                    context = 1050000;
                    output = 128000;
                  };
                };
              };
            };
          };
        };

        agents = agents.renderAgents;
        commands = commands.renderCommands;
        # Expose skill bundles to the opencode program. `skillsPkg` is a
        # small Nix derivation that packages multiple skills (antfu, ui-ux-pro-max, ...)
        # This keeps skill packaging separate from the opencode module configuration.
        skills = skillsPkg;
        context = builtins.readFile ./rules/base.md;
      };
    };

    home.persistence = lib.mkIf persist {
      "/persist" = {
        directories = [
          "./opencode"
          ".local/share/opencode"
        ];
      };
    };

    # sops.secrets."opencode_auth" = {
    #   path = "/home/${config.wktlnix.user.name}/.local/share/opencode/auth.json";
    # };
    sops.secrets."metapi_key" = { };
  };
}
