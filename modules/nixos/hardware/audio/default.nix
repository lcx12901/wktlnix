{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf mkForce;
  inherit (lib.types) listOf package;
  inherit (lib.${namespace}) mkBoolOpt mkOpt;

  cfg = config.${namespace}.hardware.audio;
in {
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
        helvum
      ])
      ++ cfg.extra-packages;

    hardware.pulseaudio.enable = mkForce false;

    wktlnix = {
      user.extraGroups = ["audio"];
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
