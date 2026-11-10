{ lib, ... }:
let
  inherit (lib.wktlnix) enabled;
in
{
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
      };
      terminal = {
        editors.neovim = enabled;
        emulators.ghostty = {
          fontSize = 15;
        };
        tools = {
          mnemos = enabled;
          nh = enabled;
          omp = enabled;
        };
      };
    };

    scenes = {
      daily = enabled;
      development = {
        enable = true;
        nodejsEnable = true;
      };
    };
  };

  home.stateVersion = "26.05";
}
