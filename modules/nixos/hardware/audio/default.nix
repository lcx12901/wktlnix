{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkForce;
  inherit (lib.types) listOf package;
  inherit (lib.${namespace}) mkBoolOpt mkOpt;

  cfg = config.${namespace}.hardware.audio;
in
{
  options.${namespace}.hardware.audio = {
    enable = mkBoolOpt false "Whether or not to enable audio support.";
    extra-packages = mkOpt (listOf package) [
      pkgs.qjackctl
      pkgs.easyeffects
    ] "Additional packages to install.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages =
      (with pkgs; [
        pulsemixer
        pavucontrol
      ])
      ++ cfg.extra-packages;

    wktlnix = {
      user.extraGroups = [ "audio" ];
    };

    security.rtkit.enable = true;

    services = {
      pipewire = {
        enable = true;
        alsa.enable = true;
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
