{ inputs, lib, ... }:
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
        discord = {
          enabled = true;
          dm = {
            policy = "allowlist";
            allowFrom = [ "962057055622012939" ];
          };
          groupPolicy = "allowlist";
          guilds = {
            "1507221972579516487" = {
              requireMention = true;
              users = [ "962057055622012939" ];

              channels = {
                "1507224368785260574" = {
                  requireMention = true;
                  users = [ "962057055622012939" ];
                };
                "1508880614806261883" = {
                  requireMention = true;
                  users = [
                    "962057055622012939"
                    "1508868407489990676"
                  ];
                };
              };
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
        apps.vesktop = enabled;
      };
      terminal = {
        editors.nvchad = enabled;
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

  home.stateVersion = "24.05";
}
