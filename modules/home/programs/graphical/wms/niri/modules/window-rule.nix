{ config, lib, ... }:
let
  inherit (lib) mkIf;
  inherit (lib.kdl) leaf plain;

  leaf' = name: arg: leaf name [ arg ];

  window-rule = plain "window-rule";
  match = leaf' "match";
in
{
  config = mkIf config.wktlnix.programs.graphical.wms.niri.enable {
    programs.niri = {
      config = [
        (window-rule [
          (leaf' "draw-border-with-background" false)
          (leaf' "geometry-corner-radius" 12.0)
          (leaf' "clip-to-geometry" true)
        ])
        (window-rule [
          (match { app-id = "^org\.gnome\.Nautilus$"; })
          (match { title = "flameshot-pin"; })
          (leaf' "open-floating" true)
        ])
        (window-rule [
          (match { title = "^yysls\.exe$"; })
          (leaf' "open-fullscreen" true)
        ])
        (window-rule [
          (match { app-id = "^zen-twilight$"; })
          (match { app-id = "^org\.telegram\.desktop$"; })
          (match { app-id = "^Bytedance-feishu$"; })
          (match { app-id = "wechat"; })
          (match { app-id = "kitty"; })
          (match { app-id = "^com\.mitchellh\.ghostty$"; })
          (leaf' "opacity" 0.85)
          (plain "background-effect" [
            (leaf' "blur" true)
          ])
        ])
        (window-rule [
          (match {
            app-id = "^Bytedance-feishu$";
            title = "图片";
          })
          (leaf' "open-floating" true)
          (leaf' "open-fullscreen" false)
          (leaf' "opacity" 1.00)
        ])
        (window-rule [
          (match { app-id = "wechat"; })
          (leaf' "open-focused" false)
        ])
      ];
    };
  };
}
