{
  # example by https://github.com/khaneliman/khanelinix
  # https://github.com/EdenQwQ/nixos
  # part disk example by https://github.com/Anomalocaridid/dotfiles
  # may be should read guide from https://nix.dev/
  description = "wktlNix";

  inputs = {
    # Core
    nixpkgs.url = "github:nixos/nixpkgs/4bd9165a9165d7b5e33ae57f3eecbcb28fb231c9";
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
    nix-openclaw = {
      url = "github:openclaw/nix-openclaw/13deaaf73ffb0ef567c83f7730320f6ee6b157b2";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    # Applications & packages
    nix4nvchad = {
      url = "github:nix-community/nix4nvchad";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nvchad-starter.follows = "nvchad-config";
    };
    nvchad-config = {
      # url = "git+file:/home/wktl/Coding/nvchad-config";
      url = "github:lcx12901/nvchad-config";
      flake = false;
    };
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    daeuniverse.url = "github:daeuniverse/flake.nix";
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
    waybar = {
      url = "github:Alexays/Waybar";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:danth/stylix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox-addons.url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    zed-extensions.url = "github:DuskSystems/nix-zed-extensions";

    # my wallpapers
    wallpapers = {
      url = "github:lcx12901/wallpapers";
      flake = false;
    };

    # bt-tracker
    bt-tracker = {
      url = "github:XIU2/TrackersListCollection";
      flake = false;
    };

    #frontend Skills
    antfu-skills = {
      url = "github:antfu/skills";
      flake = false;
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];
      imports = [ ./flake ];
    };
}
