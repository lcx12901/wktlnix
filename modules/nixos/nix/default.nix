{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkDefault isType filterAttrs mapAttrs mapAttrsToList pipe types;
  inherit (lib.internal) mkBoolOpt mkOpt;

  cfg = config.wktlNix.nix;
in {
  options.wktlNix.nix = with types; {
    enable = mkBoolOpt true "Whether or not to manage nix configuration.";
    package = mkOpt package pkgs.nixVersions.latest "Which nix package to use.";
  };

  config = mkIf cfg.enable {
    # faster rebuilding
    documentation = {
      doc.enable = false;
      info.enable = false;
      man.enable = mkDefault true;
    };

    environment = {
      etc = with inputs; {
        # set channels (backwards compatibility)
        "nix/flake-channels/system".source = self;
        "nix/flake-channels/nixpkgs".source = nixpkgs;
        "nix/flake-channels/home-manager".source = home-manager;

        # preserve current flake in /etc
        "nixos/flake".source = self;
      };

      systemPackages = [pkgs.gitMinimal];
    };

    nix = let
      mappedRegistry = pipe inputs [
        (filterAttrs (_: isType "flake"))
        (mapAttrs (_: flake: {inherit flake;}))
        (x: x // {nixpkgs.flake = inputs.nixpkgs;})
      ];

      users = [
        "root"
        "@wheel"
        config.wktlNix.user.name
      ];
    in {
      inherit (cfg) package;

      gc = {
        automatic = true;
        options = "--delete-older-than 7d";
      };

      # This will additionally add your inputs to the system's legacy channels
      # Making legacy nix commands consistent as well
      nixPath = mapAttrsToList (key: _: "${key}=flake:${key}") config.nix.registry;

      optimise = {
        automatic = true;
        dates = ["04:00"];
      };

      # pin the registry to avoid downloading and evaluating a new nixpkgs version every time
      # this will add each flake input as a registry to make nix3 commands consistent with your flake
      registry = mappedRegistry;

      settings = {
        # allow sudo users to mark the following values as trusted
        allowed-users = users;

        # only allow sudo users to manage the nix store
        trusted-users = users;

        # let the system decide the number of max jobs
        max-jobs = "auto";

        # automatically optimise symlinks
        auto-optimise-store = true;

        # specify the path to the nix registry
        flake-registry = "/etc/nix/registry.json";

        # maximum number of parallel TCP connections used to fetch imports and binary caches, 0 means no limit
        http-connections = 50;

        # build inside sandboxed environments
        sandbox = true;
        sandbox-fallback = false;

        # continue building derivations if one fails
        keep-going = true;

        # bail early on missing cache hits
        connect-timeout = 5;

        # show more log lines for failed builds
        log-lines = 30;

        # enable new nix command and flakes
        # and also "unintended" recursion as well as content addressed nix
        extra-experimental-features = [
          "flakes" # flakes
          "nix-command" # experimental nix commands
          "recursive-nix" # let nix invoke itself
          "ca-derivations" # content addressed nix
          "auto-allocate-uids" # allow nix to automatically pick UIDs, rather than creating nixbld* user accounts
          "configurable-impure-env" # allow impure environments
          "cgroups" # allow nix to execute builds inside cgroups
          "git-hashing" # allow store objects which are hashed via Git's hashing algorithm
          "verified-fetches" # enable verification of git commit signatures for fetchGit
        ];

        # don't warn me that my git tree is dirty, I know
        warn-dirty = false;

        # whether to accept nix configuration from a flake without prompting
        accept-flake-config = false;

        # execute builds inside cgroups
        use-cgroups = true;

        # for direnv GC roots
        keep-derivations = true;
        keep-outputs = true;

        # use binary cache, this is not gentoo
        # external builders can also pick up those substituters
        builders-use-substitutes = true;

        # substituters to use
        substituters = [
          "https://cache.ngi0.nixos.org" # content addressed nix cache (TODO)
          "https://cache.nixos.org" # funny binary cache
          "https://nixpkgs-wayland.cachix.org" # automated builds of *some* wayland packages
          "https://nix-community.cachix.org" # nix-community cache
          "https://hyprland.cachix.org" # hyprland
          "https://nixpkgs-unfree.cachix.org" # unfree-package cache
          "https://numtide.cachix.org" # another unfree package cache
          "https://anyrun.cachix.org" # anyrun program launcher
          "https://cache.garnix.io" # garnix binary cache, hosts prismlauncher
          "https://ags.cachix.org" # ags
        ];

        trusted-public-keys = [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "cache.ngi0.nixos.org-1:KqH5CBLNSyX184S9BKZJo1LxrxJ9ltnY2uAs5c/f1MA="
          "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
          "nixpkgs-unfree.cachix.org-1:hqvoInulhbV4nJ9yJOEr+4wxhDV4xq2d1DK7S6Nj6rs="
          "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="
          "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
          "notashelf.cachix.org-1:VTTBFNQWbfyLuRzgm2I7AWSDJdqAa11ytLXHBhrprZk="
          "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
          "ags.cachix.org-1:naAvMrz0CuYqeyGNyLgE010iUiuf/qx6kYrUv3NwAJ8="
        ];
      };
    };
  };
}
