{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (config.lib.stylix) colors;

  cfg = config.${namespace}.programs.terminal.tools.oh-my-posh;
in
{
  options.${namespace}.programs.terminal.tools.oh-my-posh = {
    enable = lib.mkEnableOption "Whether or not to enable oh-my-posh.";
  };

  config = lib.mkIf cfg.enable {
    programs.oh-my-posh = {
      enable = true;

      enableBashIntegration = true;
      enableFishIntegration = true;
      enableNushellIntegration = true;

      settings = with colors; {
        "$schema" = "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/schema.json";

        version = 3;
        final_space = true;

        blocks = [
          {
            type = "prompt";
            alignment = "left";
            segments = [
              {
                foreground = "#${base07}";
                style = "plain";
                template = "{{.Icon}} ";
                type = "os";
              }
              {
                foreground = "#${base0B}";
                style = "plain";
                template = "{{ .UserName }}@{{ .HostName }} ";
                type = "session";
              }
              {
                foreground = "#${base06}";
                properties = {
                  folder_icon = ".. ..";
                  home_icon = "~";
                  style = "agnoster_short";
                };
                style = "plain";
                template = "{{ .Path }} ";
                type = "path";
              }
              {
                foreground = "#${base0E}";
                properties = {
                  branch_icon = " ";
                  cherry_pick_icon = " ";
                  commit_icon = " ";
                  fetch_status = false;
                  fetch_upstream_icon = false;
                  merge_icon = " ";
                  no_commits_icon = " ";
                  rebase_icon = " ";
                  revert_icon = " ";
                  tag_icon = " ";
                };
                template = "{{ .HEAD }} ";
                style = "plain";
                type = "git";
              }
              {
                style = "plain";
                foreground = "#${base05}";
                template = "~>";
                type = "text";
              }
            ];
          }
        ];
      };
    };
  };
}
