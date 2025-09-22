{
  inputs,
  self,
  lib,
  ...
}:
let
  inherit (self.lib.file) parseSystemConfigurations filterNixOSSystems;

  systemsPath = ../systems;
  allSystems = parseSystemConfigurations systemsPath;
in
{
  flake = {
    nixosConfigurations = lib.mapAttrs' (
      _name:
      { system, hostname, ... }:
      {
        name = hostname;
        value = self.lib.system.mkSystem {
          inherit inputs system hostname;
          username = "wktl";
        };
      }
    ) (filterNixOSSystems allSystems);
  };
}
