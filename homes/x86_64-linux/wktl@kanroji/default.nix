{
  inputs,
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib.${namespace}) enabled;
in
{
  wktlnix = {
    user = {
      enable = true;
      inherit (config.snowfallorg.user) name;
    };

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
              (output "DP-1" [
                (leaf' "mode" "2560x1440@164.998")
                (leaf' "scale" 1.0)
                (flag "variable-refresh-rate")
              ])
            ];
        };
        apps.vesktop = enabled;
        browsers = {
          firefox = enabled;
        };
      };
      terminal = {
        emulators.kitty = {
          fontSize = 16;
        };
      };
    };

    scenes = {
      daily = enabled;
      # business = enabled;
      development = {
        enable = true;
        nodejsEnable = true;
      };
      music = enabled;
    };
  };

  home.stateVersion = "24.05";
}
