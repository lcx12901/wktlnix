{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) types mkIf mapAttrs;
  inherit (lib.${namespace}) mkBoolOpt mkOpt;

  cfg = config.${namespace}.system.fonts;
in
{
  options.${namespace}.system.fonts = with types; {
    enable = mkBoolOpt false "Whether or not to manage fonts.";
    default = mkOpt str "Maple Mono NF CN" "Default font name";
  };

  config = mkIf cfg.enable {
    environment.variables = {
      # Enable icons in tooling since we have nerdfonts.
      LOG_ICONS = "true";
    };

    fonts = {
      fontDir = {
        enable = true;
        decompressFonts = true;
      };

      packages = with pkgs; [
        # icon fonts
        material-design-icons
        font-awesome

        # icon fonts
        material-design-icons

        # Emojis
        noto-fonts-color-emoji
        noto-fonts-monochrome-emoji

        # 思源系列字体是 Adobe 主导的。其中汉字部分被称为「思源黑体」和「思源宋体」，是由 Adobe + Google 共同开发的
        source-sans # 无衬线字体，不含汉字。字族名叫 Source Sans 3 和 Source Sans Pro，以及带字重的变体，加上 Source Sans 3 VF
        source-serif # 衬线字体，不含汉字。字族名叫 Source Code Pro，以及带字重的变体
        source-han-sans # 思源黑体
        source-han-serif # 思源宋体

        # Nerd Fonts
        nerd-fonts.symbols-only # symbols icon only
        nerd-fonts.monaspace
        nerd-fonts.recursive-mono

        maple-mono.NF-CN
      ];

      enableDefaultPackages = false;

      fontconfig = {
        # allowType1 = true;
        # Defaults to true, but be explicit
        antialias = true;
        hinting.enable = true;

        defaultFonts =
          let
            common = [
              "Maple Mono NF CN"
              "Symbols Nerd Font"
              "Noto Color Emoji"
            ];
          in
          mapAttrs (_: fonts: fonts ++ common) {
            serif = [
              "Maple Mono NF CN"
              "Source Han Serif SC"
              "Source Han Serif TC"
            ];
            sansSerif = [
              "Maple Mono NF CN"
              "Source Han Sans SC"
              "Source Han Sans TC"
            ];
            emoji = [ "Noto Color Emoji" ];
            monospace = [
              "Source Code Pro Medium"
              "Source Han Mono"
            ];
          };
      };
    };
    services.kmscon = {
      enable = true;
      fonts = [
        {
          name = cfg.default;
          package = pkgs.maple-mono.NF-CN;
        }
      ];
      extraOptions = "--term xterm-256color";
      extraConfig = "font-size=12";
      # Whether to use 3D hardware acceleration to render the console.
      hwRender = true;
    };
  };
}
