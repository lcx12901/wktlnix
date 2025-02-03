{
  inputs,
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib.${namespace}) mkBoolOpt;
  inherit (inputs) yazi-plugins;

  completion = import ./keymap/completion.nix { };
  help = import ./keymap/help.nix { };
  manager = import ./keymap/manager.nix { };

  cfg = config.${namespace}.programs.terminal.tools.yazi;
in
{
  options.${namespace}.programs.terminal.tools.yazi = {
    enable = mkBoolOpt false "Whether or not to enable yazi.";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      miller
      ouch
      config.programs.ripgrep.package
      xdragon
      zoxide
      glow
    ];

    # Dumb workaround for no color with latest glow
    # https://github.com/Reledia/glow.yazi/issues/7
    home.sessionVariables = {
      "CLICOLOR_FORCE" = 1;
    };

    programs.yazi = {
      enable = true;
      package = pkgs.yazi;

      # NOTE: wrapper alias is yy
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableNushellIntegration = true;
      enableZshIntegration = true;

      initLua = ./configs/init.lua;

      keymap = lib.mkMerge [
        completion
        help
        manager
      ];

      plugins = {
        "chmod" = "${yazi-plugins}/chmod.yazi";
        "diff" = "${yazi-plugins}/diff.yazi";
        "full-border" = "${yazi-plugins}/full-border.yazi";
        "glow" = pkgs._sources.glow-yazi.src;
        "jump-to-char" = "${yazi-plugins}/jump-to-char.yazi";
        "max-preview" = "${yazi-plugins}/max-preview.yazi";
        "miller" = pkgs._sources.miller-yazi.src;
        "ouch" = pkgs._sources.ouch-yazi.src;
        "smart-enter" = "${yazi-plugins}/smart-enter.yazi";
        "smart-filter" = "${yazi-plugins}/smart-filter.yazi";
      };

      settings = import ./yazi.nix { inherit config lib pkgs; };
    };
  };
}
