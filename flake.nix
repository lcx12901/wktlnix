{
  # example by https://github.com/khaneliman/khanelinix
  # https://github.com/EdenQwQ/nixos
  # part disk example by https://github.com/Anomalocaridid/dotfiles
  # may be should read guide from https://nix.dev/
  description = "wktlNix";

  # outputs =
  #   inputs:
  #   let
  #     inherit (inputs) snowfall-lib;
  #
  #     lib = snowfall-lib.mkLib {
  #       inherit inputs;
  #       src = ./.;
  #
  #       snowfall = {
  #         meta = {
  #           name = "wktlnix";
  #           title = "wktlNix";
  #         };
  #
  #         namespace = "wktlnix";
  #       };
  #     };
  #   in
  #   lib.mkFlake {
  #     channels-config = {
  #       allowUnfree = true;
  #
  #       permittedInsecurePackages = [
  #         "immersive-translate-1.20.8"
  #       ];
  #     };
  #
  #     overlays = with inputs; [
  #       niri.overlays.niri
  #       nix-vscode-extensions.overlays.default
  #       nix-zed-extensions.overlays.default
  #     ];
  #
  #     homes.modules = with inputs; [
  #       impermanence.nixosModules.home-manager.impermanence
  #       stylix.homeModules.stylix
  #       sops-nix.homeManagerModules.sops
  #       nix-zed-extensions.homeManagerModules.default
  #       nvf.homeManagerModules.default
  #     ];
  #
  #     # Add modules to all NixOS systems.
  #     systems.modules.nixos = with inputs; [
  #       disko.nixosModules.disko
  #       sops-nix.nixosModules.sops
  #       nix-flatpak.nixosModules.nix-flatpak
  #       niri.nixosModules.niri
  #       impermanence.nixosModules.impermanence
  #       daeuniverse.nixosModules.dae
  #       stylix.nixosModules.stylix
  #     ];
  #
  #     outputs-builder = channels: { formatter = channels.nixpkgs.nixfmt; };
  #   };

  inputs = {
    # Core
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-compat.url = "https://flakehub.com/f/edolstra/flake-compat/1.tar.gz";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    # System management
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence.url = "github:nix-community/impermanence";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Applications & packages
    nvf.url = "github:notashelf/nvf";
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
    nix-flatpak.url = "github:gmodena/nix-flatpak/latest";
    daeuniverse.url = "github:daeuniverse/flake.nix";
    stylix = {
      url = "github:danth/stylix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    firefox-addons.url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    nix-zed-extensions.url = "github:DuskSystems/nix-zed-extensions";
    wallpapers = {
      url = "github:lcx12901/wallpapers";
      flake = false;
    };
    bt-tracker = {
      url = "github:XIU2/TrackersListCollection";
      flake = false;
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
      ];
      imports = [
        ./flake
      ];
    };
}
