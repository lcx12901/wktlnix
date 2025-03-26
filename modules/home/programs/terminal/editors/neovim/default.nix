{
  osConfig,
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.programs.terminal.editors.neovim;

  persist = osConfig.${namespace}.system.persist.enable;
in
{
  options.${namespace}.programs.terminal.editors.neovim = {
    enable = mkEnableOption "neovim";
  };

  config = mkIf cfg.enable {
    home = {
      sessionVariables = {
        EDITOR = "nvim";
        # DEEPSEEK_API_KEY = "$(cat ${config.sops.secrets.DEEPSEEK_API_KEY.path})";
      };

      packages = [
        (pkgs.${namespace}.wktlvim.extend {
          plugins = {
            codeium-nvim.settings = {
              config_path = "${config.sops.secrets."codeium_key".path}";
            };
          };
        })

        pkgs.neovide
      ];

      persistence = mkIf persist {
        "/persist/home/${config.${namespace}.user.name}" = {
          allowOther = true;
          directories = [ ".local/share/nvim" ];
        };
      };
    };

    sops.secrets."codeium_key" = { };

    # sops.secrets."fittencode_key" = {
    #   path = "${config.home.homeDirectory}/.local/share/nvim/fittencode/api_key.json";
    # };

    # sops.secrets."DEEPSEEK_API_KEY" = { };
  };
}
