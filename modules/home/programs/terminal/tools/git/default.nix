{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib)
    types
    mkEnableOption
    mkIf
    mkForce
    ;
  inherit (lib.${namespace}) mkOpt enabled;
  inherit (config.${namespace}) user;

  cfg = config.${namespace}.programs.terminal.tools.git;

  ignores = import ./ignores.nix;
in
{
  options.${namespace}.programs.terminal.tools.git = {
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
      git = {
        enable = true;
        package = pkgs.gitFull;
        inherit (cfg) includes userName userEmail;
        inherit (ignores) ignores;

        delta = {
          enable = true;

          options = {
            dark = true;
            features = mkForce "decorations side-by-side navigate";
            line-numbers = true;
            navigate = true;
            side-by-side = true;
            true-color = "always";
          };
        };

        extraConfig = {
          fetch = {
            prune = true;
          };

          init = {
            defaultBranch = "main";
          };

          lfs = enabled;

          # pull = {
          #   rebase = true;
          # };

          push = {
            autoSetupRemote = true;
            default = "current";
          };

          # rebase = {
          #   autoStash = true;
          # };

          # safe = {
          #   directory = [
          #     "~/$Coding/"
          #   ];
          # };
          diff.tool = "nvimdiff";
          diff.guitool = "nvimdiff";
          merge.tool = "nvimdiff";
          merge.conflictstyle = "diff3";
          mergetool.keepBackup = false;
          mergetool.prompt = false;
          mergetool."vimdiff" = {
            layout = "LOCAL,MERGED,REMOTE";
          };

          http.postBuffer = 157286400;
        };
        aliases = {
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
      };
    };
  };
}
