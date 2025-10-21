{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    types
    mkEnableOption
    mkIf
    mkForce
    ;
  inherit (lib.wktlnix) mkOpt enabled;
  inherit (config.wktlnix) user;

  cfg = config.wktlnix.programs.terminal.tools.git;

  ignores = import ./ignores.nix;
in
{
  options.wktlnix.programs.terminal.tools.git = {
    enable = mkEnableOption "Git";
    includes = mkOpt (types.listOf types.attrs) [ ] "Git includeIf paths and conditions.";
    userName = mkOpt types.str "lcx12901" "The name to configure git with.";
    userEmail = mkOpt types.str user.email "The email to configure git with.";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      bfg-repo-cleaner
      git-crypt
      git-filter-repo
      git-lfs
      gitflow
      gitleaks
      # gitlint
    ];

    programs = {
      delta = {
        enable = true;
        enableGitIntegration = true;

        options = {
          dark = true;
          features = mkForce "decorations side-by-side navigate";
          line-numbers = true;
          navigate = true;
          side-by-side = true;
        };
      };

      git = {
        enable = true;
        package = pkgs.gitFull;

        inherit (cfg) includes;
        inherit (ignores) ignores;

        settings = {
          branch.sort = "-committerdate";

          fetch = {
            prune = true;
          };

          init = {
            defaultBranch = "main";
          };

          lfs = enabled;

          push = {
            autoSetupRemote = true;
            default = "current";
          };

          diff.tool = "nvimdiff";
          diff.guitool = "nvimdiff";
          merge.tool = "nvimdiff";
          merge.conflictstyle = "diff3";
          mergetool = {
            keepBackup = false;
            prompt = false;
            "vimdiff" = {
              layout = "LOCAL,MERGED,REMOTE";
            };
          };

          http.postBuffer = 157286400;

          alias = {
            # common aliases
            br = "branch";
            co = "checkout";
            st = "status";
            ls = "log --pretty=format:\"%C(yellow)%h%Cred%d\\\\ %Creset%s%Cblue\\\\ [%cn]\" --decorate";
            ll = "log --pretty=format:\"%C(yellow)%h%Cred%d\\\\ %Creset%s%Cblue\\\\ [%cn]\" --decorate --numstat";
            cm = "commit -m"; # commit via `git cm <message>`
            ca = "commit -am"; # commit all changes via `git ca <message>`
            dc = "diff --cached";
          };

          user = {
            name = cfg.userName;
            email = cfg.userEmail;
          };
        };
      };
    };

    sops.secrets."github_copilot_token" = {
      path = "/home/${config.wktlnix.user.name}/.config/github-copilot/apps.json";
    };
  };
}
