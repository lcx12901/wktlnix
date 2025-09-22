{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    types
    mkIf
    mkEnableOption
    mapAttrs
    ;
  inherit (lib.wktlnix) mkOpt;

  cfg = config.wktlnix.system.fonts;
in
{
  options.wktlnix.system.fonts = with types; {
    enable = mkEnableOption "Whether or not to manage fonts.";
    default = mkOpt str "Maple Mono NF CN" "Default font name";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      font-manager
      fontpreview
      smile
    ];

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
        corefonts

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
        nerd-fonts.iosevka
        cascadia-code
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
              "Cascadia Mono NF"
              "Symbols Nerd Font"
              "Noto Color Emoji"
            ];
          in
          mapAttrs (_: fonts: fonts ++ common) {
            serif = [
              # "Source Han Serif SC"
              # "Source Han Serif TC"
              "Maple Mono NF CN"
            ];
            sansSerif = [
              # "Source Han Sans SC"
              # "Source Han Sans TC"
              "Maple Mono NF CN"
            ];
            emoji = [ "Noto Color Emoji" ];
            monospace = [
              "Maple Mono NF CN"
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
