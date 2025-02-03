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
      };

      packages = [
        (pkgs.${namespace}.wktlvim.extend {
          plugins = {
            codeium-nvim.settings = {
              config_path = "${config.sops.secrets."codeium_key".path}";
            };
          };
        })
      ];

      persistence = mkIf persist {
        "/persist/home/${config.${namespace}.user.name}" = {
          allowOther = true;
          directories = [ ".local/share/nvim" ];
        };
      };
    };

    sops.secrets = {
      "codeium_key" = {
        sopsFile = lib.snowfall.fs.get-file "secrets/default.yaml";
      };
    };
  };
}
