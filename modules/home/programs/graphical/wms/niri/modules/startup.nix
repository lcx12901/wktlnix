{
  inputs,
  # osConfig,
  config,
  lib,
  pkgs,
  DISPLAY,
  ...
}:
let
  inherit (lib) getExe getExe';
  inherit (inputs.niri.lib.kdl)
    leaf
    flag
    plain
    ;

  sh = getExe' config.programs.bash.package "sh";
  sleep = getExe' pkgs.coreutils "sleep";
  waybar = getExe config.programs.waybar.package;
  xwayland-satellite = getExe pkgs.xwayland-satellite;
  swww = getExe pkgs.swww;
  swww-daemon = getExe' pkgs.swww "swww-daemon";
  swaybg = getExe pkgs.swaybg;
  flameshot = getExe pkgs.flameshot;
  wl-paste = getExe' pkgs.wl-clipboard "wl-paste";
  cliphist = getExe' pkgs.cliphist "cliphist";
in
(
  let
    spawn-at-startup = leaf "spawn-at-startup";
  in
  [
    (leaf "screenshot-path" "${config.xdg.userDirs.pictures}/screenshots/%Y-%m-%d_%H:%M:%S.png")
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
    (spawn-at-startup [
      xwayland-satellite
      "${DISPLAY}"
    ])
    (spawn-at-startup [ swww-daemon ])
    (spawn-at-startup [
      swww
      "img"
      "${inputs.wallpapers}/kobeni_by_lxlbanner.png"
    ])
    (spawn-at-startup [
      swaybg
      "-i"
      "${inputs.wallpapers}/kobeni_by_lxlbanner-blur.png"
    ])
    (spawn-at-startup [
      sh
      "-c"
      "${sleep} 10; fcitx5 --replace"
    ])
    (spawn-at-startup [ flameshot ])
    (plain "layout" [
      (plain "border" [
        (leaf "width" 3)
        (leaf "active-color" "#ca9ee6")
        (leaf "inactive-color" "#babbf1")
      ])
      (plain "focus-ring" [
        (flag "off")
        (leaf "width" 3)
        (leaf "active-color" "#ca9ee6")
        (leaf "inactive-color" "#babbf1")
      ])
      (plain "tab-indicator" [
        (flag "hide-when-single-tab")
      ])
      (plain "preset-column-widths" [
        (leaf "proportion" (1. / 4.))
        (leaf "proportion" (1. / 3.))
        (leaf "proportion" (1. / 2.))
        (leaf "proportion" (2. / 3.))
        (leaf "proportion" (3. / 4.))
        (leaf "proportion" (4. / 4.))
      ])
      (flag "always-center-single-column")
      (leaf "center-focused-column" "never")
      (leaf "default-column-display" "tabbed")
      (plain "default-column-width" [
        (leaf "proportion" (1. / 2.))
      ])
      (flag "empty-workspace-above-first")
      (leaf "gaps" 16)
      (plain "shadow" [
        (flag "on")
      ])
    ])
    (plain "animations" [
      (plain "window-close" [
        (leaf "spring" {
          damping-ratio = 1.0;
          stiffness = 800;
          epsilon = 0.0001;
        })
      ])
    ])
    (plain "environment" [
      (leaf "DISPLAY" DISPLAY)
      (leaf "GSK_RENDERER" "gl")
      (leaf "NIXOS_OZONE_WL" "1")
      (leaf "MOZ_ENABLE_WAYLAND" "1")
      (leaf "QT_QPA_PLATFORM" "wayland;xcb")
      (leaf "QT_WAYLAND_DISABLE_WINDOWDECORATION" "1")
      (leaf "XDG_CURRENT_DESKTOP" "niri")
      (leaf "XDG_SESSION_TYPE" "wayland")
    ])
  ]
)
++ (
  let
    layer-rule = plain "layer-rule";
    match = leaf "match";
  in
  [
    (layer-rule [
      (match { namespace = "^wallpaper$"; })
      (leaf "place-within-backdrop" true)
    ])
  ]
)
