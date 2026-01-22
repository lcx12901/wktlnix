{
  osConfig,
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  persist = osConfig.wktlnix.system.persist.enable;

  cfg = config.wktlnix.programs.terminal.tools.distrobox;
in
{
  options.wktlnix.programs.terminal.tools.distrobox = {
    enable = mkEnableOption "distrobox";
  };

  config = mkIf cfg.enable {
    programs.distrobox = {
      enable = true;

      settings = {
        container_always_pull = "1";
        container_generate_entry = 0;
      };

      containers = {
        archlinux = {
          image = "archlinux";
          entry = true;
        };
      };
    };

    home.persistence = lib.mkIf persist {
      "/persist" = {
        directories = [
          ".local/share/applications"
          ".local/share/containers/storage"
        ];
      };
    };
  };
}
