{
  inputs,
  config,
  lib,
  pkgs,
  system,
  namespace,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.programs.graphical.browsers.zen;

  policyFormat = pkgs.formats.json { };

  policies = {
    PasswordManagerEnabled = false;
  };
in
{
  options.${namespace}.programs.graphical.browsers.zen = {
    enable = mkBoolOpt false "Whether or not to enable zen-browser.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ inputs.zen-browser.packages."${system}".default ];

    environment.etc =
      let
        policiesJSON = policyFormat.generate "firefox-policies.json" { inherit policies; };
      in
      {
        "firefox/policies/policies.json".source = "${policiesJSON}";
      };
  };
}
