{
  inputs,
  config,
  lib,
  system,
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
      inputs.wktlpkgs.packages.${system}.waydroid-script
    ];

    environment.persistence."/persist" = {
      hideMounts = true;
      directories = [
        "/home/.waydroid"
      ];
      users."${username}" = {
        directories = [
          ".waydroid"
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
