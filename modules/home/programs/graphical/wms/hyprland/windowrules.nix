{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.${namespace}.programs.graphical.wms.hyprland;
in {
  config = mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      settings = {
        windowrule = [
          "noblur,.*"

          ## Dialogs
          "float,title:^(Open File)(.*)$"
          "float,title:^(Select a File)(.*)$"
          "float,title:^(Choose wallpaper)(.*)$"
          "float,title:^(Open Folder)(.*)$"
          "float,title:^(Save As)(.*)$"
          "float,title:^(Library)(.*)$"
          "float,title:^(File Upload)(.*)$"
          "float,title:打开文件"
          "float,title:打开文件夹"
        ];

        windowrulev2 = [
          # make Firefox PiP window floating and sticky
          "float,title:^([Pp]icture[-\s]?[Ii]n[-\s]?[Pp]icture)(.*)$"
          "pin, title:^([Pp]icture[-\s]?[Ii]n[-\s]?[Pp]icture)(.*)$"

          ## No shadow for tiled windows
          "noshadow,floating:0"

          "float,title:图片"
          "float,title:微信"
          "float,class:^(org.gnome.Nautilus|nautilus)$"
          "float,class:discord"

          "float,class:org.telegram.desktop"
          "center 1,class:org.telegram.desktop"
          "size 55% 60%,class:org.telegram.desktop"

          "opacity 1 override, class:firefox"
        ];

        layerrule = [
          "xray 1, .*"
          "blur, shell:*"
          "ignorealpha 0.6, shell:*"
          "noanim, noanim"
        ];
      };
    };
  };
}
