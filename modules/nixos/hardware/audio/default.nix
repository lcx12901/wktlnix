{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) types mkIf mkForce;
  inherit (lib.${namespace}) mkBoolOpt mkOpt;

  cfg = config.${namespace}.hardware.audio;
in {
  options.${namespace}.hardware.audio = with types; {
    enable = mkBoolOpt false "Whether or not to enable audio support.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages =
      with pkgs;
      [
        pulsemixer
        pavucontrol
        helvum
      ]
      ++ cfg.extra-packages;

    hardware.pulseaudio.enable = mkForce false;

    wktlnix = {
      user.extraGroups = [ "audio" ];
    };

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      audio.enable = true;
      jack.enable = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };
  };
}