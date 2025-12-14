{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf getExe getExe';
  inherit (lib.kdl)
    leaf
    flag
    plain
    ;

  leaf' = name: arg: leaf name [ arg ];

  spawn-at-startup = leaf "spawn-at-startup";

  waybar = getExe config.programs.waybar.package;
  xwayland-satellite-unstable = getExe pkgs.xwayland-satellite-unstable;
  swww = getExe pkgs.swww;
  swww-daemon = getExe' pkgs.swww "swww-daemon";
  swaybg = getExe pkgs.swaybg;
  wl-paste = getExe' pkgs.wl-clipboard "wl-paste";
  cliphist = getExe' pkgs.cliphist "cliphist";

  wallpaper = config.stylix.image;
  blur-wallpaper = pkgs.runCommand "wallpaper-blur.jpg" { } ''
    ${pkgs.imagemagick}/bin/magick ${wallpaper} -blur 0x30 $out
  '';
in
{
  config = mkIf config.wktlnix.programs.graphical.wms.niri.enable {
    programs.niri = {
      config =
        (with config.lib.stylix.colors.withHashtag; [
          (leaf' "screenshot-path" "${config.xdg.userDirs.pictures}/screenshots/%Y-%m-%d_%H:%M:%S.png")
          (plain "hotkey-overlay" [
            (flag "skip-at-startup")
          ])
          (flag "prefer-no-csd")
          (spawn-at-startup [ waybar ])
          (spawn-at-startup [
            wl-paste
            "--watch"
            cliphist
            "store"
          ])
          (spawn-at-startup [ xwayland-satellite-unstable ])
          (spawn-at-startup [ swww-daemon ])
          (spawn-at-startup [
            swww
            "img"
            "${wallpaper}"
          ])
          (spawn-at-startup [
            swaybg
            "-i"
            "${blur-wallpaper}"
          ])
          (plain "cursor" [
            (leaf' "xcursor-theme" config.stylix.cursor.name)
            (leaf' "xcursor-size" config.stylix.cursor.size)
          ])
          (plain "input" [
            (plain "keyboard" [ (flag "numlock") ])
          ])
          (plain "xwayland-satellite" [
            (leaf' "path" "${xwayland-satellite-unstable}")
          ])
          (plain "layout" [
            (plain "border" [
              (leaf' "width" 3)
              (leaf' "active-gradient" {
                from = base07;
                to = base0E;
                angle = 45;
              })
              (leaf' "inactive-color" base02)
            ])
            (plain "focus-ring" [ (flag "off") ])
            (plain "tab-indicator" [
              (flag "hide-when-single-tab")
            ])
            (plain "preset-column-widths" [
              (leaf' "proportion" (1. / 4.))
              (leaf' "proportion" (1. / 3.))
              (leaf' "proportion" (1. / 2.))
              (leaf' "proportion" (2. / 3.))
              (leaf' "proportion" (3. / 4.))
              (leaf' "proportion" (4. / 4.))
            ])
            (flag "always-center-single-column")
            (leaf' "center-focused-column" "never")
            (leaf' "default-column-display" "tabbed")
            (plain "default-column-width" [
              (leaf' "proportion" (1. / 2.))
            ])
            (flag "empty-workspace-above-first")
            (leaf' "gaps" 16)
            (plain "shadow" [
              (flag "on")
            ])
          ])
          (plain "animations" [
            (plain "window-close" [
              (leaf' "spring" {
                damping-ratio = 1.0;
                stiffness = 800;
                epsilon = 0.0001;
              })
            ])
          ])
          (plain "environment" [
            (leaf' "GSK_RENDERER" "gl")
            (leaf' "NIXOS_OZONE_WL" "1")
            (leaf' "MOZ_ENABLE_WAYLAND" "1")
            (leaf' "QT_QPA_PLATFORM" "wayland;xcb")
            (leaf' "QT_WAYLAND_DISABLE_WINDOWDECORATION" "1")
            (leaf' "XDG_CURRENT_DESKTOP" "niri")
            (leaf' "XDG_SESSION_TYPE" "wayland")
          ])
        ])
        ++ (
          let
            layer-rule = plain "layer-rule";
            match = leaf' "match";
          in
          [
            (layer-rule [
              (match { namespace = "^wallpaper$"; })
              (leaf' "place-within-backdrop" true)
            ])
          ]
        );
    };
  };
}
