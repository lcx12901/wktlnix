{
  lib,
  rustPlatform,
  clangStdenv,
  fetchFromGitHub,
  linkFarm,
  fetchgit,
  runCommand,
  gn,
  neovim,
  ninja,
  makeWrapper,
  pkg-config,
  python3,
  removeReferencesTo,
  SDL2,
  fontconfig,
  libxrandr,
  libxi,
  libxext,
  libxcursor,
  libx11,
  libglvnd,
  libxkbcommon,
  wayland,
}:

rustPlatform.buildRustPackage.override { stdenv = clangStdenv; } (finalAttrs: {
  pname = "neovide";
  version = "2026-07-20";

  src = fetchFromGitHub {
    owner = "neovide";
    repo = "neovide";
    rev = "7af518d72c33907b57d3a6c54c67969857a13871";
    hash = "sha256-C1qNdHSYi2z33PZqmZaUYiCkGuhIVGvphSXT09O0eYU=";
  };

  cargoHash = "sha256-kl1TXq2CDahMCWRReWxAJqDpH4Gx0xwWkZKcDCHQWUM=";

  env = {
    SKIA_SOURCE_DIR =
      let
        repo = fetchFromGitHub {
          owner = "rust-skia";
          repo = "skia";
          # see rust-skia:skia-bindings/Cargo.toml#package.metadata skia
          tag = "m148-0.97.0";
          hash = "sha256-uFnYX6ZDg+cJwLyCe6IGB6M3aCyI/+q2aYP4JfHm544=";
        };
        # The externals for skia are taken from skia/DEPS
        externals = linkFarm "skia-externals" (
          lib.mapAttrsToList (name: value: {
            inherit name;
            path = fetchgit value;
          }) (lib.importJSON ./skia-externals.json)
        );
      in
      runCommand "source" { } ''
        cp -R ${repo} $out
        chmod -R +w $out
        ln -s ${externals} $out/third_party/externals
      '';

    SKIA_GN_COMMAND = "${gn}/bin/gn";
    SKIA_NINJA_COMMAND = "${ninja}/bin/ninja";
  };

  nativeBuildInputs = [
    makeWrapper
    pkg-config
    python3 # skia
    removeReferencesTo
  ];

  nativeCheckInputs = [ neovim ];

  buildInputs = [
    SDL2
    fontconfig
    rustPlatform.bindgenHook
  ];

  postFixup =
    let
      libPath = lib.makeLibraryPath [
        libglvnd
        libxkbcommon
        libx11
        libxcursor
        libxext
        libxrandr
        libxi
        wayland
      ];
    in
    ''
      # library skia embeds the path to its sources
      remove-references-to -t "$SKIA_SOURCE_DIR" \
        $out/bin/neovide
      wrapProgram $out/bin/neovide \
        --add-flags "--no-startup-message-capture" \
        --prefix LD_LIBRARY_PATH : ${libPath}        
    '';

  postInstall = ''
    for n in 16x16 32x32 48x48 256x256; do
      install -m444 -D "assets/neovide-$n.png" \
        "$out/share/icons/hicolor/$n/apps/neovide.png"
    done
    install -m444 -Dt $out/share/icons/hicolor/scalable/apps assets/neovide.svg
    install -m444 -Dt $out/share/applications assets/neovide.desktop
  '';

  disallowedReferences = [ finalAttrs.env.SKIA_SOURCE_DIR ];
})
