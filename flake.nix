{
  # example by https://github.com/khaneliman/khanelinix
  # part disk example by https://github.com/Anomalocaridid/dotfiles
  # may be should read guide from https://nix.dev/
  description = "wktlNix";

  outputs = inputs: let
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

        # TODO: wechat need, when can cleanup
        permittedInsecurePackages = ["openssl-1.1.1w"];
      };

      overlays = with inputs; [
        nix-ld-rs.overlays.default
        nur.overlay
        catppuccin-vsc.overlays.default
      ];

      homes.modules = with inputs; [
        catppuccin.homeManagerModules.catppuccin
        impermanence.nixosModules.home-manager.impermanence
        nixvim.homeManagerModules.nixvim
        spicetify-nix.homeManagerModules.default
        ags.homeManagerModules.default
      ];

      # Add modules to all NixOS systems.
      systems.modules.nixos = with inputs; [
        nixos-wsl.nixosModules.wsl
        disko.nixosModules.disko
        agenix.nixosModules.default
        impermanence.nixosModules.impermanence
        daeuniverse.nixosModules.dae
      ];
    };

  inputs = {
    # NixPkgs (nixos-unstable)
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
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
    };

    # Declarative disk partitioning
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Run unpatched dynamically compiled binaries
    nix-ld-rs = {
      url = "github:nix-community/nix-ld-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # many of the extensions in nixpkgs are significantly out-of-date
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

    # Hyprlock
    hyprlock = {
      url = "github:hyprwm/Hyprlock";
      # NOTE: required to prevent red screen on lock
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";

    # Hyprland user contributions flake
    hyprland-contrib.url = "github:hyprwm/contrib";

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

    # agenix (Secrets)
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:nix-community/impermanence";

    catppuccin.url = "github:catppuccin/nix";

    # Spicetify
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Aylur's gtk shell (ags)
    ags = {
      url = "github:Aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # my wallpapers
    wallpapers = {
      url = "github:lcx12901/wallpapers";
      flake = false;
    };

    catppuccin-vsc.url = "https://flakehub.com/f/catppuccin/vscode/*.tar.gz";

    daeuniverse.url = "github:daeuniverse/flake.nix";
  };
}
