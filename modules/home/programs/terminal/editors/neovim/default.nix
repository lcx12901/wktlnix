{
  inputs,
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
        pkgs.neovide
        (pkgs.${namespace}.wktlvim.extend {
          plugins = {
            codeium-nvim.settings = {
              config_path = "${osConfig.age.secrets."codeium.config".path}";
            };
            lsp.servers.nixd.settings =
              let
                flake = ''(builtins.getFlake "${inputs.self}")'';
              in
              {
                options = rec {
                  nix-darwin.expr = ''${flake}.darwinConfigurations.khanelimac.options'';
                  nixos.expr = ''${flake}.nixosConfigurations.khanelinix.options'';
                  home-manager.expr = ''${nixos.expr}.home-manager.users.type.getSubOptions [ ]'';
                };
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
  };
}
