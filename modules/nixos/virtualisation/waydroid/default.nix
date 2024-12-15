{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt enabled;

  cfg = config.${namespace}.virtualisation.waydroid;

  username = config.${namespace}.user.name;
in
{
  options.${namespace}.virtualisation.waydroid = {
    enable = mkBoolOpt false "Whether or not to enable Waydroid.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.${namespace}.waydroid_script
    ];

    environment.persistence."/persist" = {
      hideMounts = true;
      directories = [
        "/home/.waydroid"
      ];
      users."${username}" = {
        directories = [
          "waydroid"
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
