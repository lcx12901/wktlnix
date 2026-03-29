{ lib, pkgs, ... }:
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
        editors = {
          zed = {
            enable = true;
            userSettings = {
              buffer_font_size = lib.mkForce 18;
              ui_font_size = lib.mkForce 18;
              terminal.font_size = lib.mkForce 18;
            };
          };
        };
      };
      terminal = {
        editors.nvchad = enabled;
        emulators.ghostty = {
          fontSize = 15;
        };
        tools = {
          distrobox = enabled;
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

  home.packages = with pkgs; [
    tsukimi
  ];

  home.stateVersion = "24.05";
}
