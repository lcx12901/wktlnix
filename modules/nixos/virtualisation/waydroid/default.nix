{ config, lib, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (lib.wktlnix) enabled;

  cfg = config.wktlnix.virtualisation.waydroid;

  username = config.wktlnix.user.name;
in
{
  options.wktlnix.virtualisation.waydroid = {
    enable = mkEnableOption "Whether or not to enable Waydroid.";
  };

  ### /var/lib/waydroid/waydroid_base.prop
  # qemu.hw.mainkeys=1
  # persist.waydroid.width=720
  # persist.waydroid.height=1280
  # persist.waydroid.dpi=280

  config = mkIf cfg.enable {
    environment.persistence."/persist" = {
      hideMounts = true;

      directories = [ "/var/lib/waydroid" ];

      users."${username}" = {
        directories = [
          ".share/waydroid"
          ".local/share/applications"
          ".local/share/waydroid"
        ];
      };
    };

    virtualisation = {
      waydroid = enabled;
    };
  };
}
