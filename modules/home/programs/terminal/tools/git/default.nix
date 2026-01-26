{
  inputs,
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
      git-absorb
      git-crypt
      git-filter-repo
      git-lfs
      gitflow
      gitleaks
      gitlint
      tig
    ];

    programs = {
      delta = {
        enable = true;
        enableGitIntegration = true;

        options = {
          dark = true;
          features = mkForce "decorations side-by-side navigate catppuccin-macchiato";
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

        maintenance.enable = true;

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
            a = "add";
            ### Commit, checkout, and push
            c = "commit --verbose";
            co = "checkout";
            p = "push";
            ### Status
            s = "status -sb";
            ### Stash and list stashes
            st = "stash";
            stl = "stash list";
            ### Diff, diff stat, diff cached
            d = "diff";
            ds = "diff --stat";
            dc = "diff --cached";
            ### Add remote origin
            rao = "remote add origin";
            ### Checkout, create and checkout new branch
            cob = "checkout -b";
          };

          user = {
            name = cfg.userName;
            email = cfg.userEmail;
          };
        };
      };

      mergiraf = enabled;
    };

    home.file.".copilot/skills/vue-best-practices" = {
      source = "${inputs.vue-skills}/skills/vue-best-practices";
      recursive = true;
    };

    sops.secrets."github_copilot_token" = {
      path = "/home/${config.wktlnix.user.name}/.config/github-copilot/apps.json";
    };
  };
}
