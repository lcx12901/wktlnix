{
  inputs,
  osConfig,
  config,
  lib,
  system,
  ...
}:
let
  wktlvimConfiguration = inputs.wktlvim.nixvimConfigurations.${system}.wktlvim;
  wktlvim = wktlvimConfiguration.config.build.package;

  persist = osConfig.wktlnix.system.persist.enable;

  cfg = config.wktlnix.programs.terminal.editors.neovim;
in
{
  options.wktlnix.programs.terminal.editors.neovim = {
    enable = lib.mkEnableOption "neovim";
  };

  config = lib.mkIf cfg.enable {
    home = {
      sessionVariables.EDITOR = "nvim";

      packages = [
        wktlvim
      ];

      persistence = lib.mkIf persist {
        "/persist" = {
          directories = [
            ".local/share/nvim"
            ".local/state/nvim"
          ];
        };
      };
    };

    sops.secrets =
      let
        dir = config.home.homeDirectory;
      in
      {
        wakatime = {
          path = "${dir}/.wakatime.cfg";
        };
        github_copilot_cli_config = {
          path = "${dir}/.config/.copilot/config.json";
          mode = "0600";
        };
      };
  };
}
