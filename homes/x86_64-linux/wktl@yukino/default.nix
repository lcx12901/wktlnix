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
        # editors = {
        #   vscode = enabled;
        # };
        # apps.vesktop = enabled;
      };
      terminal = {
        editors.neovim = enabled;
        tools = {
          git = {
            userName = "linchengxu";
            userEmail = "linchengxu@z9yun.com";
          };
          distrobox = enabled;
          nh = enabled;
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
