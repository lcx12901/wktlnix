{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.wktlnix.programs.graphical.addons.fcitx5;
in
{
  options.wktlnix.programs.graphical.addons.fcitx5 = {
    enable = mkEnableOption "Whether to enable fcitx5.";
  };

  config = mkIf cfg.enable {
    # https://github.com/ulic-youthlic/flakes/blob/5f6a71f47f555747cfe2c41b79fc5a52f4bac9bb/nixos/modules/i18n.nix#L29
    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5 = {
        addons = with pkgs; [
          kdePackages.fcitx5-chinese-addons
          fcitx5-gtk
          libsForQt5.fcitx5-qt
          (fcitx5-rime.override {
            rimeDataPkgs = [
              rime-all
            ];
          })
        ];

        waylandFrontend = true;

        settings = {
          globalOptions = {
            Hotkey = {
              EnumerateWithTriggerKeys = true;
              AltTriggerKeys = "";
              EnumerateForwardKeys = "";
              EnumerateBackwardKeys = "";
              EnumerateSkipFirst = "False";
              EnumerateGroupForwardKeys = "";
              EnumerateGroupBackwardKeys = "";
              ActivateKeys = "";
              DeactivateKeys = "";
              PrevPage = "";
              NextPage = "";
              PrevCandidate = "";
              NextCandidate = "";
              TogglePreedit = "";
              ModifierOnlyKeyTimeout = 250;
            };
            "Hotkey/TriggerKeys" = {
              "0" = "Control+Shift+space";
            };
            Behavior = {
              ActiveByDefault = "False";
              AllowInputMethodForPassword = "False";
              AutoSavePeriod = 30;
              CompactInputMethodInformation = "True";
              CustomXkbOption = "";
              DefaultPageSize = 7;
              DisabledAddons = "";
              EnabledAddons = "";
              OverrideXkbOption = "False";
              PreeditEnabledByDefault = "True";
              PreloadInputMethod = "True";
              ShareInputState = "No";
              ShowFirstInputMethodInformation = "True";
              ShowInputMethodInformation = "True";
              ShowPreeditForPassword = "False";
              resetStateWhenFocusIn = "No";
              showInputMethodInformationWhenFocusIn = "False";
            };
          };
          inputMethod = {
            "Groups/0" = {
              Name = "Default";
              "Default Layout" = "us";
              DefaultIM = "rime";
            };
            "Groups/0/Items/0" = {
              Name = "keyboard-us";
              Layout = "";
            };
            "Groups/0/Items/1" = {
              Name = "rime";
              Layout = "";
            };
            "Groups/0/Items/2" = {
              Name = "keyboard-us-dvp";
              Layout = "";
            };
            "GroupOrder" = {
              "0" = "Default";
            };
          };
        };
      };
    };
  };
}
