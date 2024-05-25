{config, lib, pkgs, namespace, ...}: let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.programs.terminal.shell.fish;
in {
  options.${namespace}.programs.terminal.shell.fish = {
    enable = mkBoolOpt true "Whether or not to enable fish shell.";
  };

  config = mkIf cfg.enable {
    programs.fish = {
      enable = true;

      interactiveShellInit = ''
        set fish_greeting # Disable greeting
        ${pkgs.any-nix-shell}/bin/any-nix-shell fish --info-right | source
      '';

      shellAliases = {
        du = "${pkgs.ncdu}/bin/ncdu --color dark -rr -x";
        ls = "${pkgs.eza}/bin/eza";
        ll = "ls -a";
        tree = "${pkgs.eza}/bin/eza -T";
      };
    };
  };
}