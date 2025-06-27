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
        niri.overlays.niri
        nix-zed-extensions.overlays.default
      ];

      homes.modules = with inputs; [
        catppuccin.homeModules.catppuccin
        impermanence.nixosModules.home-manager.impermanence
        # spicetify-nix.homeManagerModules.default
        sops-nix.homeManagerModules.sops
        nix-zed-extensions.homeManagerModules.default
        betterfox-nix.homeManagerModules.betterfox
      ];

      # Add modules to all NixOS systems.
      systems.modules.nixos = with inputs; [
        disko.nixosModules.disko
        sops-nix.nixosModules.sops
        nix-flatpak.nixosModules.nix-flatpak
        niri.nixosModules.niri
        impermanence.nixosModules.impermanence
        daeuniverse.nixosModules.dae
        stylix.nixosModules.stylix
      ];
    };

  inputs = {
    # Core
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    snowfall-flake = {
      url = "github:snowfallorg/flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Addons
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    betterfox-nix = {
      url = "github:HeitorAugustoLN/betterfox-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    nix-zed-extensions.url = "github:DuskSystems/nix-zed-extensions";

    # Applications
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    waybar = {
      url = "github:Alexays/Waybar";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ags = {
      url = "github:Aylur/ags/v3";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak/latest";
    impermanence.url = "github:nix-community/impermanence";
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    daeuniverse.url = "github:daeuniverse/flake.nix";
    ghostty.url = "github:ghostty-org/ghostty";

    # Theme
    #FIXME: updated to include accents, https://github.com/catppuccin/nix/pull/343
    catppuccin.url = "github:catppuccin/nix";
    stylix = {
      url = "github:danth/stylix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
        # Optional inputs removed
        flake-compat.follows = "";
      };
    };
    catppuccin-vsc.url = "https://flakehub.com/f/catppuccin/vscode/*.tar.gz";

    # my wallpapers
    wallpapers = {
      url = "github:lcx12901/wallpapers";
      flake = false;
    };

    wktlvim.url = "github:lcx12901/nixvim-part";
    # wktlvim.url = "git+file:/home/wktl/Coding/nixvim-part";
  };
}
