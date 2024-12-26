{
  # example by https://github.com/khaneliman/khanelinix
  # https://github.com/Misterio77/nix-config
  # part disk example by https://github.com/Anomalocaridid/dotfiles
  # may be should read guide from https://nix.dev/
  description = "wktlNix";

  outputs =
    inputs:
    let
      inherit (inputs) snowfall-lib;

      lib = snowfall-lib.mkLib {
        inherit inputs;
        src = ./.;

        snowfall = {
          meta = {
            name = "wktlnix";
            title = "wktlNix";
          };

          namespace = "wktlnix";
        };
      };
    in
    lib.mkFlake {
      channels-config = {
        allowUnfree = true;
      };

      overlays = with inputs; [
        catppuccin-vsc.overlays.default
        nur.overlays.default
      ];

      homes.modules = with inputs; [
        catppuccin.homeManagerModules.catppuccin
        impermanence.nixosModules.home-manager.impermanence
        spicetify-nix.homeManagerModules.default
        ags.homeManagerModules.default
        # nur.modules.home-manager.default
      ];

      # Add modules to all NixOS systems.
      systems.modules.nixos = with inputs; [
        nixos-wsl.nixosModules.wsl
        disko.nixosModules.disko
        agenix.nixosModules.default
        impermanence.nixosModules.impermanence
      ];
    };

  inputs = {
    # NixPkgs (nixos-unstable)
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };

    # NixPkgs (nixos-unstable)
    nixpkgs-small = {
      url = "github:nixos/nixpkgs/nixos-unstable-small";
    };

    # NixOS WSL Support
    nixos-wsl = {
      url = "github:nix-community/nixos-wsl";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Home Manager (master)
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Snowfall Lib
    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Snowfall Flake
    snowfall-flake = {
      url = "github:snowfallorg/flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Nix User Repository (master)
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Declarative disk partitioning
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # many of the extensions in nixpkgs are significantly out-of-date
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

    hyprland = {
      url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hyprlock
    hyprlock = {
      url = "github:hyprwm/Hyprlock";
      inputs.nixpkgs.follows = "hyprland/nixpkgs";
    };

    # Hyprland user contributions flake
    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "hyprland/nixpkgs";
    };

    # Hyprland plugins
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    # Weekly updating nix-index database
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # NixPkgs-Wayland
    nixpkgs-wayland = {
      url = "github:nix-community/nixpkgs-wayland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # agenix (Secrets)
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:nix-community/impermanence";

    nixvim.url = "github:nix-community/nixvim";

    #FIXME: updated to include accents, https://github.com/catppuccin/nix/pull/343
    catppuccin.url = "github:catppuccin/nix";

    catppuccin-fcitx5 = {
      url = "github:catppuccin/fcitx5";
      flake = false;
    };

    # Spicetify
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    waybar = {
      url = "github:Alexays/Waybar";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Aylur's gtk shell (ags)
    ags = {
      url = "github:Aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # my wallpapers
    wallpapers = {
      url = "github:lcx12901/wallpapers";
      flake = false;
    };

    catppuccin-vsc.url = "https://flakehub.com/f/catppuccin/vscode/*.tar.gz";

    ayugram-desktop.url = "github:/ayugram-port/ayugram-desktop/release?submodules=1";

    blink-cmp = {
      url = "github:saghen/blink.cmp";
    };

    blink-compat = {
      url = "github:saghen/blink.compat";
      flake = false;
    };

    yazi-plugins = {
      url = "github:yazi-rs/plugins";
      flake = false;
    };
  };
}
