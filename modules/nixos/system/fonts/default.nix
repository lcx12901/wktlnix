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
        # Desktop Fonts
        lxgw-wenkai
        # Noto 系列字体是 Google 主导的，名字的含义是「没有豆腐」（no tofu），因为缺字时显示的方框或者方框被叫作 tofu
        # Noto 系列字族名只支持英文，命名规则是 Noto + Sans 或 Serif + 文字名称。
        # 其中汉字部分叫 Noto Sans/Serif CJK SC/TC/HK/JP/KR，最后一个词是地区变种。
        noto-fonts # 大部分文字的常见样式，不包含汉字
        noto-fonts-cjk-sans # 汉字部分
        noto-fonts-emoji # 彩色的表情符号字体
        noto-fonts-extra # 提供额外的字重和宽度变种
        corefonts # MS fonts
        b612 # high legibility
        material-icons
        material-design-icons
        work-sans
        comic-neue
        source-sans
        inter
        lexend

        # Emojis
        noto-fonts-color-emoji
        twemoji-color-font

        # Nerd Fonts
        # "https://github.com/NixOS/nixpkgs/blob/nixos-unstable-small/pkgs/data/fonts/nerd-fonts/manifests/fonts.json"
        nerd-fonts.symbols-only # symbols icon only
        nerd-fonts.monaspace
        nerd-fonts.recursive-mono

        maple-mono.NF-CN
      ];

      enableDefaultPackages = true;

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
            serif = [ "Maple Mono NF CN" ];
            sansSerif = [ "Maple Mono NF CN" ];
            emoji = [ "Noto Color Emoji" ];
            monospace = [
              "Maple Mono NF CN"
            ];
          };
      };
    };
  };
}
