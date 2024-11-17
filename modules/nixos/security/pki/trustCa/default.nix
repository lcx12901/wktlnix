{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.security.pki.trustCa;
in
{
  options.${namespace}.security.pki.trustCa = {
    enable = mkBoolOpt false "trustCa";
  };

  config = lib.mkIf cfg.enable {
    security.pki.certificates = [
      (builtins.readFile ./ryomori.cer)
    ];
  };
}
