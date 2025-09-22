{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.wktlnix.programs.terminal.tools.zellij;
in
{
  options.wktlnix.programs.terminal.tools.zellij = {
    enable = mkEnableOption "Whether or not to enable zellij.";
  };

  config = mkIf cfg.enable {
    programs = {
      zellij = {
        enable = true;

        settings = {
          # custom defined layouts
          layout_dir = "${./layouts}";

          # clipboard provider
          copy_command = "wl-copy";

          auto_layouts = true;

          default_layout = "dev"; # or compact
          default_mode = "locked";
          support_kitty_keyboard_protocol = false;

          on_force_close = "quit";
          pane_frames = true;
          pane_viewport_serialization = true;
          scrollback_lines_to_serialize = 1000;
          session_serialization = true;

          ui.pane_frames = {
            rounded_corners = true;
            hide_session_name = true;
          };

          # load internal plugins from built-in paths
          plugins = {
            tab-bar.path = "tab-bar";
            status-bar.path = "status-bar";
            strider.path = "strider";
            compact-bar.path = "compact-bar";
          };

          theme = "catppuccin-macchiato";
        };
      };
    };
  };
}
