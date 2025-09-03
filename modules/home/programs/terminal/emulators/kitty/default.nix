{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib.${namespace}) mkOpt;
  cfg = config.${namespace}.programs.terminal.emulators.kitty;
in
{
  options.${namespace}.programs.terminal.emulators.kitty = {
    enable = lib.mkEnableOption "Kitty";
    fontSize = mkOpt lib.types.int 14 "Font size for Kitty terminal emulator";
  };

  config = lib.mkIf cfg.enable {
    home.shellAliases = {
      # Shared clipboard that works over ssh
      clipboard = "kitten clipboard";
      # Pretty diff
      diff = "kitty +kitten diff";
      # QOL alias for copying terminfo
      ssh = "kitty +kitten ssh";
      # cat for images
      icat = "kitty +kitten icat";
    };

    programs.kitty = {
      enable = true;

      font.size = lib.mkForce cfg.fontSize;

      enableGitIntegration = true;

      keybindings = {
        "ctrl+shift+v" = "paste_from_clipboard";
        "ctrl+shift+s" = "paste_from_selection";
        "ctrl+shift+c" = "copy_to_clipboard";
        "shift+insert" = "paste_from_selection";

        "ctrl+shift+up" = "scroll_line_up";
        "ctrl+shift+down" = "scroll_line_down";
        "ctrl+shift+k" = "scroll_line_up";
        "ctrl+shift+j" = "scroll_line_down";
        "ctrl+shift+page_up" = "scroll_page_up";
        "ctrl+shift+page_down" = "scroll_page_down";
        "ctrl+shift+home" = "scroll_home";
        "ctrl+shift+end" = "scroll_end";
        "ctrl+shift+h" = "show_scrollback";

        "ctrl+shift+enter" = "new_window";
        "ctrl+shift+n" = "new_os_window";
        "ctrl+shift+w" = "close_window";
        "ctrl+shift+]" = "next_window";
        "ctrl+shift+[" = "previous_window";
        "ctrl+shift+f" = "move_window_forward";
        "ctrl+shift+b" = "move_window_backward";
        "ctrl+shift+`" = "move_window_to_top";
        "ctrl+shift+1" = "first_window";
        "ctrl+shift+2" = "second_window";
        "ctrl+shift+3" = "third_window";
        "ctrl+shift+4" = "fourth_window";
        "ctrl+shift+5" = "fifth_window";
        "ctrl+shift+6" = "sixth_window";
        "ctrl+shift+7" = "seventh_window";
        "ctrl+shift+8" = "eighth_window";
        "ctrl+shift+9" = "ninth_window";
        "ctrl+shift+0" = "tenth_window";

        "ctrl+shift+right" = "next_tab";
        "ctrl+shift+left" = "previous_tab";
        "ctrl+shift+t" = "new_tab";
        "ctrl+shift+q" = "close_tab";
        "ctrl+shift+l" = "next_layout";
        "ctrl+shift+." = "move_tab_forward";
        "ctrl+shift+," = "move_tab_backward";
        "ctrl+shift+alt+t" = "set_tab_title";

        "ctrl+shift+equal" = "increase_font_size";
        "ctrl+shift+minus" = "decrease_font_size";
        "ctrl+shift+backspace" = "restore_font_size";
      };

      settings = {
        italic_font = "auto";
        bold_font = "auto";
        bold_italic_font = "auto";

        adjust_line_height = 0;
        adjust_column_width = 0;
        box_drawing_scale = "0.001, 1, 1.5, 2";

        # Cursor
        cursor_trail = 100;
        cursor_trail_decay = "0.1 0.4";
        cursor_shape = "block";
        cursor_blink_interval = -1;
        cursor_stop_blinking_after = "15.0";

        # Scrollback
        scrollback_lines = 10000;
        scrollback_pager = "less";
        wheel_scroll_multiplier = "5.0";

        # URLs
        url_style = "double";
        open_url_with = "default";
        copy_on_select = "yes";

        select_by_word_characters = ":@-./_~?& = %+#";

        # Mouse
        click_interval = "0.5";
        mouse_hide_wait = 0;
        focus_follows_mouse = "no";

        # Performance
        repaint_delay = 20;
        input_delay = 2;
        sync_to_monitor = "no";

        # Tab bar
        tab_bar_edge = "top";
        tab_bar_align = "center";
        tab_bar_style = "separator";
        tab_separator = " • ";
        tab_bar_margin_height = "0.0 0.0";
        tab_title_max_length = 30;
        tab_title_template = "{index}: {title.split(' ')[0]}";

        # Bell
        visual_bell_duration = "0.0";
        enable_audio_bell = "yes";
        bell_on_tab = "yes";

        # Window
        remember_window_size = "no";
        initial_window_width = 700;
        initial_window_height = 400;
        window_border_width = 0;
        window_margin_width = 0;
        window_padding_width = 0;
        inactive_text_alpha = "1.0";
        placement_strategy = "center";
        hide_window_decorations = "yes";
        confirm_os_window_close = -1;

        enabled_layouts = "*";

        # Shell
        shell = ".";
        close_on_child_death = "no";
        allow_remote_control = "yes";
        term = "xterm-kitty";
      };

      shellIntegration = {
        enableBashIntegration = true;
        enableFishIntegration = true;
        enableZshIntegration = true;
      };
    };
  };
}
