# Restore pnpm to nixpkgs version after nix-openclaw overlay overrides it.
# nix-openclaw overlays pnpm_11 to 11.2.2, which cascades to pnpm via
# nixpkgs' `pnpm = pnpm_11` recursive binding. This overlay restores both.
{ inputs, ... }:
final: prev:
let
  nixpkgsPnpm = final.callPackage (inputs.nixpkgs + "/pkgs/development/tools/pnpm/default.nix") { };
in
{
  pnpm_11 = nixpkgsPnpm.pnpm_11;
  pnpm = nixpkgsPnpm.pnpm_11;
}
