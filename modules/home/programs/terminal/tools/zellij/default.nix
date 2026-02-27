{
  osConfig,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  persist = osConfig.wktlnix.system.persist.enable;

  cfg = config.wktlnix.programs.terminal.tools.zellij;
in
{
  options.wktlnix.programs.terminal.tools.zellij = {
    enable = mkEnableOption "zellij";

    package = pkgs.zellij.overrideAttrs (_oldAttrs: {
      patches = lib.optionals pkgs.stdenv.hostPlatform.isLinux [
        (pkgs.fetchpatch2 {
          url = "https://github.com/zellij-org/zellij/commit/60acd439985339e518f090821c0e4eb366ce6014.patch?full_index=1";
          hash = "sha256-pCFDEbgceNzZAjxSXme/nQ4iQc8qNw2IOMtec16cr8k=";
        })
      ];
    });
  };

  imports = [
    ./layouts/dev.nix
    ./keybinds.nix
  ];

  config = mkIf cfg.enable {
    programs = {
      zellij = {
        enable = true;

        settings = {
          copy_command = "wl-copy";

          auto_layouts = true;
          default_layout = "dev";
          default_mode = "locked";

          on_force_close = "quit";
          pane_frames = true;
          pane_viewport_serialization = true;
          scrollback_lines_to_serialize = 100;
          session_serialization = true;
          post_command_discovery_hook = ''
            case "$RESURRECT_COMMAND" in
              /nix/store/*/bin/*)
                printf '%s\n' "''${RESURRECT_COMMAND#*/bin/}"
                ;;
              *)
                printf '%s\n' "$RESURRECT_COMMAND"
                ;;
            esac
          '';

          ui.pane_frames = {
            rounded_corners = true;
            hide_session_name = true;
          };

          plugins = {
            tab-bar.path = "tab-bar";
            status-bar.path = "status-bar";
            strider.path = "strider";
            compact-bar.path = "compact-bar";
          };

          theme = "catppuccin-frappe";
        };
      };
    };

    home.persistence = lib.mkIf persist {
      "/persist" = {
        directories = [ ".local/cache/zellij" ];
      };
    };
  };
}
