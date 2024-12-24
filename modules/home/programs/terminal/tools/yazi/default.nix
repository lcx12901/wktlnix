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

      keymap = lib.mkMerge [
        completion
        help
        manager
      ];

      settings = import ./yazi.nix { inherit config lib pkgs; };
    };

    xdg.configFile = {
      "yazi/plugins/chmod.yazi".source = "${yazi-plugins}/chmod.yazi";
      "yazi/plugins/diff.yazi".source = "${yazi-plugins}/diff.yazi";
      "yazi/plugins/full-border.yazi".source = "${yazi-plugins}/full-border.yazi";
      "yazi/plugins/jump-to-char.yazi".source = "${yazi-plugins}/jump-to-char.yazi";
      "yazi/plugins/max-preview.yazi".source = "${yazi-plugins}/max-preview.yazi";
      "yazi/plugins/smart-enter.yazi".source = "${yazi-plugins}/smart-enter.yazi";
      "yazi/plugins/smart-filter.yazi".source = "${yazi-plugins}/smart-filter.yazi";
    };
  };
}
