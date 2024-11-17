{
  osConfig,
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.programs.graphical.apps.discord;

  persist = osConfig.${namespace}.system.persist.enable;

  catppuccin = config.${namespace}.theme.catppuccin;

  discord-wrapped =
    (pkgs.discord-canary.override {
      nss = pkgs.nss_latest;
      withOpenASAR = true;
      withVencord = true;
    }).overrideAttrs
      (old: {
        libPath = old.libPath + ":${pkgs.libglvnd}/lib";
        nativeBuildInputs = old.nativeBuildInputs ++ [ pkgs.makeWrapper ];

        postFixup = ''
          wrapProgram $out/opt/DiscordCanary/DiscordCanary \
            --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform=wayland}}"
        '';
      });
in
{
  options.${namespace}.programs.graphical.apps.discord = {
    enable = mkBoolOpt false "discord";
  };

  config = mkIf cfg.enable {
    home = {
      packages = [ discord-wrapped ];

      persistence = mkIf persist {
        "/persist/home/${config.${namespace}.user.name}" = {
          directories = [
            ".config/discordcanary"
            ".config/Vencord"
          ];
        };
      };
    };

    xdg.configFile."Vencord/themes/custom.css".text = ''
      /**
      * @name Catppuccin Mocha
      * @author winston#0001
      * @authorId 505490445468696576
      * @version 0.2.0
      * @description 🎮 Soothing pastel theme for Discord
      * @website https://github.com/catppuccin/discord
      * @invite r6Mdz5dpFc
      * **/

      @import url("https://catppuccin.github.io/discord/dist/catppuccin-${catppuccin.flavor}-${catppuccin.accent}.theme.css");
    '';
  };
}
