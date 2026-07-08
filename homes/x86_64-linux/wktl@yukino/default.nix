{ inputs, lib, ... }:
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
              inherit (inputs.niri.lib.kdl) node leaf flag;
              output = arg: node "output" [ arg ];
              leaf' = name: arg: leaf name [ arg ];
            in
            [
              (output "DP-2" [
                (flag "focus-at-startup")
                (leaf' "mode" "1920x1080@100.000")
                (leaf' "scale" 1.0)
              ])
              (output "HDMI-A-1" [
                (leaf' "mode" "1920x1080@100.000")
                (leaf' "scale" 1.0)
              ])

            ];
        };
      };
      terminal = {
        editors.neovim = {
          enable = true;
          extendConfig = {
            opts = {
              guifont = lib.mkForce "Maple Mono NF CN:h14";
            };
          };
        };
        tools = {
          git = {
            userName = "linchengxu";
            userEmail = "linchengxu@z9yun.com";
          };
          nh = enabled;
          opencode = enabled;
        };
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

  home.stateVersion = "26.05";
}
