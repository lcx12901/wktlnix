{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf getExe getExe';
  inherit (lib.kdl)
    node
    leaf
    flag
    plain
    ;

  node' =
    name: arg: children:
    node name [ arg ] children;

  leaf' = name: arg: leaf name [ arg ];

  spawn = leaf "spawn";

  noctalia =
    cmd:
    [
      "noctalia"
      "msg"
    ]
    ++ (pkgs.lib.splitString " " cmd);

  sh = getExe' config.programs.bash.package "sh";
  flameshot = getExe config.services.flameshot.package;
  telegram = getExe pkgs.telegram-desktop;
  wpctl = getExe' pkgs.wireplumber "wpctl";
  ghostty = getExe config.programs.ghostty.package;
  zen-browser = getExe' config.programs.zen-browser.package "zen-twilight";
  wlCopy = lib.getExe' pkgs.wl-clipboard "wl-copy";
  magick = lib.getExe' pkgs.imagemagick "magick";

  colorPickerCommand = ''
    color="$(niri msg pick-color | awk '/Hex:/ { print $2 }')" &&
    [ -n "$color" ] &&
    printf '%s' "$color" | ${wlCopy} &&
    ${magick} convert -size 32x32 "xc:$color" /tmp/color.png &&
    notify-send "Color Code:" "$color" -h "string:bgcolor:$color" --icon /tmp/color.png -u critical -t 4000
  '';
in
{
  config = mkIf config.wktlnix.programs.graphical.wms.niri.enable {
    programs.niri = {
      config = [
        (plain "binds" (
          [
            (plain "Mod+W" [
              (spawn (noctalia "panel-toggle launcher"))
            ])
            (node' "Mod+X" { repeat = false; } [
              (spawn (noctalia "panel-toggle clipboard"))
            ])
            (plain "Mod+Shift+P" [
              (spawn (noctalia "session lock"))
            ])
            (plain "Mod+Shift+Slash" [
              (flag "show-hotkey-overlay")
            ])
            (plain "Mod+Return" [
              (spawn [ ghostty ])
            ])
            (plain "Mod+T" [
              (spawn [ telegram ])
            ])
            (plain "Mod+V" [
              (spawn [ colorPickerCommand ])
            ])
            (plain "Mod+B" [
              (spawn [ zen-browser ])
            ])
            (plain "Mod+Space" [
              (flag "toggle-column-tabbed-display")
            ])
            (node' "XF86AudioRaiseVolume" { allow-when-locked = true; } [
              (spawn [
                wpctl
                "set-volume"
                "@DEFAULT_AUDIO_SINK@"
                "0.1+"
              ])
            ])
            (node' "XF86AudioLowerVolume" { allow-when-locked = true; } [
              (spawn [
                wpctl
                "set-volume"
                "@DEFAULT_AUDIO_SINK@"
                "0.1-"
              ])
            ])
            (node' "XF86AudioMute" { allow-when-locked = true; } [
              (spawn [
                wpctl
                "set-volume"
                "@DEFAULT_AUDIO_SINK@"
                "toggle"
              ])
            ])
            (node' "XF86AudioMicMute" { allow-when-locked = true; } [
              (spawn [
                wpctl
                "set-volume"
                "@DEFAULT_AUDIO_SOURCE@"
                "toggle"
              ])
            ])
            (plain "Mod+Q" [
              (flag "close-window")
            ])
            (node' "Mod+O" { repeat = false; } [
              (flag "toggle-overview")
            ])
            (plain "Mod+Left" [
              (flag "focus-column-left")
            ])
            (plain "Mod+Down" [
              (flag "focus-window-down")
            ])
            (plain "Mod+Up" [
              (flag "focus-window-up")
            ])
            (plain "Mod+Right" [
              (flag "focus-column-right")
            ])
            (plain "Mod+H" [
              (flag "focus-column-or-monitor-left")
            ])
            (plain "Mod+J" [
              (flag "focus-window-or-workspace-down")
            ])
            (plain "Mod+K" [
              (flag "focus-window-or-workspace-up")
            ])
            (plain "Mod+L" [
              (flag "focus-column-or-monitor-right")
            ])
            (plain "Mod+Shift+Left" [
              (flag "move-column-left")
            ])
            (plain "Mod+Shift+Down" [
              (flag "move-window-down")
            ])
            (plain "Mod+Shift+Up" [
              (flag "move-window-up")
            ])
            (plain "Mod+Shift+Right" [
              (flag "move-column-right")
            ])
            (plain "Mod+Shift+H" [
              (flag "move-column-left-or-to-monitor-left")
            ])
            (plain "Mod+Shift+J" [
              (flag "move-window-down-or-to-workspace-down")
            ])
            (plain "Mod+Shift+K" [
              (flag "move-window-up-or-to-workspace-up")
            ])
            (plain "Mod+Shift+L" [
              (flag "move-column-right-or-to-monitor-right")
            ])
            (plain "Mod+Home" [
              (flag "focus-column-first")
            ])
            (plain "Mod+End" [
              (flag "focus-column-last")
            ])
            (plain "Mod+Ctrl+Home" [
              (flag "move-column-to-first")
            ])
            (plain "Mod+Ctrl+End" [
              (flag "move-column-to-last")
            ])
            (plain "Mod+Ctrl+Left" [
              (flag "focus-monitor-left")
            ])
            (plain "Mod+Ctrl+Down" [
              (flag "focus-monitor-down")
            ])
            (plain "Mod+Ctrl+Up" [
              (flag "focus-monitor-up")
            ])
            (plain "Mod+Ctrl+Right" [
              (flag "focus-monitor-right")
            ])
            (plain "Mod+Ctrl+H" [
              (flag "focus-monitor-left")
            ])
            (plain "Mod+Ctrl+J" [
              (flag "focus-monitor-down")
            ])
            (plain "Mod+Ctrl+K" [
              (flag "focus-monitor-up")
            ])
            (plain "Mod+Ctrl+L" [
              (flag "focus-monitor-right")
            ])
            (plain "Mod+Shift+Ctrl+Left" [
              (flag "move-column-to-monitor-left")
            ])
            (plain "Mod+Shift+Ctrl+Down" [
              (flag "move-column-to-monitor-down")
            ])
            (plain "Mod+Shift+Ctrl+Up" [
              (flag "move-column-to-monitor-up")
            ])
            (plain "Mod+Shift+Ctrl+Right" [
              (flag "move-column-to-monitor-right")
            ])
            (plain "Mod+Shift+Ctrl+H" [
              (flag "move-column-to-monitor-left")
            ])
            (plain "Mod+Shift+Ctrl+J" [
              (flag "move-column-to-monitor-down")
            ])
            (plain "Mod+Shift+Ctrl+K" [
              (flag "move-column-to-monitor-up")
            ])
            (plain "Mod+Shift+Ctrl+L" [
              (flag "move-column-to-monitor-right")
            ])
            (plain "Mod+Page_Down" [
              (flag "focus-workspace-down")
            ])
            (plain "Mod+Page_Up" [
              (flag "focus-workspace-up")
            ])
            (plain "Mod+U" [
              (flag "focus-workspace-down")
            ])
            (plain "Mod+I" [
              (flag "focus-workspace-up")
            ])
            (plain "Mod+Shift+Page_Down" [
              (flag "move-column-to-workspace-down")
            ])
            (plain "Mod+Shift+Page_Up" [
              (flag "move-column-to-workspace-up")
            ])
            (plain "Mod+Shift+U" [
              (flag "move-column-to-workspace-down")
            ])
            (plain "Mod+Shift+I" [
              (flag "move-column-to-workspace-up")
            ])
            (plain "Mod+Ctrl+Page_Down" [
              (flag "move-workspace-down")
            ])
            (plain "Mod+Ctrl+Page_Up" [
              (flag "move-workspace-up")
            ])
            (plain "Mod+Ctrl+U" [
              (flag "move-workspace-down")
            ])
            (plain "Mod+Ctrl+I" [
              (flag "move-workspace-up")
            ])
            (node' "Mod+Shift+WheelScrollDown" { cooldown-ms = 150; } [
              (flag "focus-workspace-down")
            ])
            (node' "Mod+Shift+WheelScrollUp" { cooldown-ms = 150; } [
              (flag "focus-workspace-up")
            ])
            (plain "Mod+WheelScrollDown" [
              (flag "focus-column-right")
            ])
            (plain "Mod+WheelScrollUp" [
              (flag "focus-column-left")
            ])
          ]
          ++ (lib.concatMap (n: [
            (plain "Mod+${toString n}" [
              (leaf' "focus-workspace" n)
            ])
            (plain "Mod+Shift+${toString n}" [
              (leaf' "move-column-to-workspace" n)
            ])
          ]) (lib.range 1 9))
          ++ [
            (plain "Mod+F" [
              (flag "toggle-window-floating")
            ])
            (plain "Mod+Shift+F" [
              (flag "toggle-windowed-fullscreen")
            ])
            (plain "Mod+Tab" [
              (flag "focus-window-previous")
            ])
            (plain "Mod+Shift+Tab" [
              (flag "switch-focus-between-floating-and-tiling")
            ])
            (plain "Mod+BracketLeft" [
              (flag "consume-or-expel-window-left")
            ])
            (plain "Mod+BracketRight" [
              (flag "consume-or-expel-window-right")
            ])
            (plain "Mod+Comma" [
              (flag "consume-window-into-column")
            ])
            (plain "Mod+Period" [
              (flag "expel-window-from-column")
            ])
            (node' "Mod+R" { repeat = false; } [
              (flag "switch-preset-column-width")
            ])
            (node' "Mod+Shift+R" { repeat = false; } [
              (flag "switch-preset-window-height")
            ])
            (plain "Mod+Ctrl+R" [
              (flag "reset-window-height")
            ])
            (node' "Mod+M" { repeat = false; } [
              (flag "maximize-column")
            ])
            (node' "Mod+Shift+M" { repeat = false; } [
              (flag "fullscreen-window")
            ])
            (plain "Mod+Z" [
              (flag "center-column")
            ])
            (node' "Mod+Minus" { repeat = false; } [
              (leaf' "set-column-width" "-10%")
            ])
            (node' "Mod+Equal" { repeat = false; } [
              (leaf' "set-column-width" "+10%")
            ])
            (node' "Mod+Shift+Minus" { repeat = false; } [
              (leaf' "set-window-height" "-10%")
            ])
            (node' "Mod+Shift+Equal" { repeat = false; } [
              (leaf' "set-window-height" "+10%")
            ])
            (plain "Print" [
              (spawn [
                flameshot
                "gui"
              ])
            ])
            (plain "Shift+Print" [
              (leaf' "screenshot" { show-pointer = false; })
            ])
            (plain "Ctrl+Print" [
              (leaf' "screenshot-screen" { write-to-disk = false; })
            ])
            (plain "Alt+Print" [
              (leaf' "screenshot-window" { write-to-disk = false; })
            ])
            (plain "Mod+Shift+Q" [
              (flag "quit")
            ])
            (plain "Mod+E" [
              (flag "expand-column-to-available-width")
            ])
            (plain "Mod+Shift+S" [
              (flag "toggle-keyboard-shortcuts-inhibit")
            ])
            (plain "Mod+Shift+C" [
              (flag "set-dynamic-cast-window")
            ])
            (plain "Mod+Shift+Ctrl+C" [
              (flag "clear-dynamic-cast-target")
            ])
          ]
        ))
      ];
    };
  };
}
