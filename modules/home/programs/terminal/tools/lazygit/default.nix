{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption mkForce;

  accent = "#${config.lib.stylix.colors.base0D}";
  muted = "#${config.lib.stylix.colors.base03}";

  cfg = config.wktlnix.programs.terminal.tools.lazygit;
in
{
  options.wktlnix.programs.terminal.tools.lazygit = {
    enable = mkEnableOption "Whether or not to enable lazygit.";
  };

  config = mkIf cfg.enable {
    programs.lazygit = {
      enable = true;

      settings = mkForce {
        disableStartupPopups = true;
        notARepository = "skip";
        promptToReturnFromSubprocess = false;
        update.method = "never";

        git = {
          commit.signOff = true;
          parseEmoji = true;
        };

        gui = {
          theme = {
            activeBorderColor = [
              accent
              "bold"
            ];
            inactiveBorderColor = [ muted ];
          };
          showListFooter = false;
          showRandomTip = false;
          showCommandLog = false;
          nerdFontsVersion = "3";
        };
      };
    };

    home.shellAliases = {
      lg = "lazygit";
    };
  };
}
