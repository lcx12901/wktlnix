{ lib, ... }:
let
  inherit (lib.wktlnix) enabled;
in
{
  wktlnix = {
    user = enabled;

    programs = {
      terminal = {
        tools = {
          eza = enabled;
        };
      };
    };
  };

  stylix.overlays.enable = false;

  home.stateVersion = "24.05";
}
