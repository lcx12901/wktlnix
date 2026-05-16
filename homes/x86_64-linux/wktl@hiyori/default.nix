{ lib, ... }:
let
  inherit (lib.wktlnix) enabled;
in
{
  wktlnix = {
    user = enabled;

    system.xdg = enabled;

    services.openclaw = {
      enable = true;
      channels = {
        telegram = {
          allowFrom = [
            975201632
            (-5281713495)
          ];
          groups = {
            "*" = {
              requireMention = true;
            };
          };
        };
      };
    };

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

  home.stateVersion = "24.05";
}
