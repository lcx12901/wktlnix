{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption mkForce;

  cfg = config.wktlnix.hardware.audio;
in
{
  options.wktlnix.hardware.audio = {
    enable = mkEnableOption "Whether or not to enable audio support.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      pulsemixer
      pavucontrol
    ];

    wktlnix = {
      user.extraGroups = [ "audio" ];
    };

    security.rtkit.enable = true;

    services = {
      pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        audio.enable = true;
        jack.enable = true;
        pulse.enable = true;
        wireplumber.enable = true;
        extraConfig.pipewire."99-low-latency" = {
          context.properties = {
            default = {
              clock = {
                rate = 48000;
                quantum = 512;
                min-quantum = 256;
                max-quantum = 8192;
              };
            };
          };
        };
      };

      pulseaudio.enable = mkForce false;
    };
  };
}
