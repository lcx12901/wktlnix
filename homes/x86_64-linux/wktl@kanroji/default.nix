{ lib, pkgs, ... }:
let
  inherit (lib.wktlnix) enabled;
in
{
  home.packages = [ pkgs.tsukimi ];

  wktlnix = {
    user = enabled;

    system.xdg = enabled;

    programs = {
      graphical = {
        wms.niri = {
          enable = true;
          extraConfig =
            let
              inherit (lib.kdl) node leaf flag;
              output = arg: node "output" [ arg ];
              leaf' = name: arg: leaf name [ arg ];
            in
            [
              (output "DP-1" [
                (leaf' "mode" "2560x1440@164.998")
                (leaf' "scale" 1.0)
                (flag "variable-refresh-rate")
              ])
            ];
        };
        apps.vesktop = enabled;
        # editors.zed = enabled;
        browsers = {
          firefox = enabled;
        };
      };
      terminal = {
        emulators.kitty = {
          fontSize = 16;
        };
        tools.nh = enabled;
      };
    };

    scenes = {
      daily = enabled;
      business = enabled;
      development = {
        enable = true;
        nodejsEnable = true;
      };
      music = enabled;
    };
  };

  home.stateVersion = "24.05";
}
