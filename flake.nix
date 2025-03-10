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
      ];

      homes.modules = with inputs; [
        catppuccin.homeManagerModules.catppuccin
        impermanence.nixosModules.home-manager.impermanence
        spicetify-nix.homeManagerModules.default
        sops-nix.homeManagerModules.sops
        niri.homeModules.niri
      ];

      # Add modules to all NixOS systems.
      systems.modules.nixos = with inputs; [
        disko.nixosModules.disko
        sops-nix.nixosModules.sops
        impermanence.nixosModules.impermanence
        daeuniverse.nixosModules.dae
      ];
    };

  inputs = {
    # NixPkgs (nixos-unstable)
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    # Home Manager (master)
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
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

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Declarative disk partitioning
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # many of the extensions in nixpkgs are significantly out-of-date
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
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

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    impermanence.url = "github:nix-community/impermanence";

    nixvim.url = "github:nix-community/nixvim";

    #FIXME: updated to include accents, https://github.com/catppuccin/nix/pull/343
    catppuccin.url = "github:catppuccin/nix";

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

    blink-cmp = {
      url = "github:saghen/blink.cmp";
    };

    snacks-nvim = {
      url = "github:folke/snacks.nvim";
      flake = false;
    };

    fittencode-nvim = {
      url = "github:luozhiya/fittencode.nvim";
      flake = false;
    };

    typescript-tools-nvim = {
      url = "github:Parsifa1/typescript-tools.nvim";
      flake = false;
    };

    yazi-plugins = {
      url = "github:yazi-rs/plugins";
      flake = false;
    };

    daeuniverse.url = "github:daeuniverse/flake.nix";

    ghostty.url = "github:ghostty-org/ghostty";

    zen-browser.url = "github:0xc000022070/zen-browser-flake";
  };
}
