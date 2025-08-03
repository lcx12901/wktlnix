{
  config,
  lib,
  namespace,
  ...
}:
let
  accent = "#${config.lib.stylix.colors.base0D}";
  muted = "#${config.lib.stylix.colors.base03}";

  cfg = config.${namespace}.programs.terminal.tools.lazygit;
in
{
  options.${namespace}.programs.terminal.tools.lazygit = {
    enable = lib.mkEnableOption "Whether or not to enable lazygit.";
  };

  config = lib.mkIf cfg.enable {
    programs.lazygit = {
      enable = true;

      settings = lib.mkForce {
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
