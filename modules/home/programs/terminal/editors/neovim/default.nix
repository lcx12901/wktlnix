{
  inputs,
  osConfig,
  config,
  system,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  wktlvimCfg = inputs.wktlvim.nixvimConfigurations.${system}.wktlvim.extendModules {
    modules = [
      {
        config = {
          # plugins.windsurf-nvim.settings.config_path = "${config.sops.secrets."codeium_key".path}";
          plugins.lsp.servers.unocss.package = pkgs.${namespace}.unocss-language-server;
        };
      }
    ];
  };

  wktlvim = wktlvimCfg.config.build.package;

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
        DEEPSEEK_API_KEY = "$(cat ${config.sops.secrets.DEEPSEEK_API_KEY.path})";
      };

      packages = [
        wktlvim
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
    sops.secrets."DEEPSEEK_API_KEY" = { };
  };
}
