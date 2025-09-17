{ inputs }:
let
  inherit (inputs.nixpkgs.lib)
    mapAttrs
    mkOption
    types
    toUpper
    substring
    stringLength
    mkDefault
    mkForce
    ;
in
rec {
  # Enable a module with optional configuration
  enable =
    module: config:
    {
      imports = [ module ];
    }
    // config;

  # Option creation helpers
  mkOpt =
    type: default: description:
    mkOption { inherit type default description; };

  mkOpt' = type: default: mkOpt type default null;

  mkBoolOpt = mkOpt types.bool;

  mkBoolOpt' = mkOpt' types.bool;

  # Standard enable/disable patterns
  enabled = {
    enable = true;
  };

  disabled = {
    enable = false;
  };

  # String utilities
  capitalize =
    s:
    let
      len = stringLength s;
    in
    if len == 0 then "" else (toUpper (substring 0 1 s)) + (substring 1 len s);

  # Boolean utilities
  boolToNum = bool: if bool then 1 else 0;

  # Attribute manipulation utilities
  default-attrs = mapAttrs (_key: mkDefault);

  force-attrs = mapAttrs (_key: mkForce);

  nested-default-attrs = mapAttrs (_key: default-attrs);

  nested-force-attrs = mapAttrs (_key: force-attrs);

  # Create a module with common options
  mkModule =
    {
      name,
      description ? "",
      options ? { },
      config ? { },
    }:
    { lib, ... }:
    {
      options.khanelinix.${name} = lib.mkOption {
        type = lib.types.submodule {
          options = {
            enable = lib.mkEnableOption description;
          }
          // options;
        };
        default = { };
      };

      config = lib.mkIf config.khanelinix.${name}.enable config;
    };
}
