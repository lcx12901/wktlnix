{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib.${namespace}) enabled;
in {
  wktlnix = {
    user = {
      enable = true;
      inherit (config.snowfallorg.user) name;
    };

    system.xdg = enabled;

    programs = {
      graphical = {
        wms.hyprland = enabled;
        browsers.firefox = {
          enable = true;
          gpuAcceleration = true;
          hardwareDecoding = true;
        };
        editors.vscode = enabled;
        apps.discord = enabled;
        video = enabled;
      };
      terminal.editors.neovim = {
        enable = lib.mkForce false;
      };
    };

    scenes = {
      daily = enabled;
      business = enabled;
      development = enabled;
    };
  };

  home = {
    sessionVariables = {
      EDITOR = "nvim";
    };

    packages =
      (with pkgs; [
        parsec-bin
        neovide
        alejandra
      ])
      ++ [pkgs.${namespace}.wktlvim];
  };

  home.persistence = {
    "/persist/home/${config.${namespace}.user.name}" = {
      allowOther = true;
      directories = [
        ".parsec"
        ".parsec-persistent"
      ];
    };
  };

  home.stateVersion = "24.05";
}
