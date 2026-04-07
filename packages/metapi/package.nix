{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  gcc,
  gnumake,
  makeBinaryWrapper,
  nodejs_22,
  pkg-config,
  python3,
  stdenv,
  vips,
  ...
}:
let
  nodejs = nodejs_22;
in
buildNpmPackage (finalAttrs: {
  pname = "metapi";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "cita-777";
    repo = "metapi";
    rev = "v${finalAttrs.version}";
    hash = "sha256-OfS8iAjP1yU40RNlJeFEvih4jn9Ab4joTgLfRD6e1pQ=";
  };

  npmDepsHash = "sha256-6C4SIoP0+HdIoODkWq6uEJppOOfzFiNf/5FEtTG/Eo0=";
  inherit nodejs;
  npmInstallFlags = [ "--ignore-scripts" ];
  npmRebuildFlags = [ "--ignore-scripts" ];

  nativeBuildInputs = [
    gcc
    gnumake
    makeBinaryWrapper
    pkg-config
    python3
  ];

  buildInputs = [
    stdenv.cc.cc.lib
    vips
  ];

  buildPhase = ''
    runHook preBuild

    npm rebuild esbuild --no-audit --no-fund
    npm rebuild better-sqlite3 --build-from-source --no-audit --no-fund

    npm run build:web
    npm run build:server

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    npm prune --omit=dev --ignore-scripts --no-audit --no-fund

    mkdir -p $out/{bin,lib/metapi}
    cp -r dist drizzle package.json node_modules $out/lib/metapi/

    makeWrapper ${lib.getExe nodejs} $out/bin/metapi \
      --chdir $out/lib/metapi \
      --set NODE_ENV production \
      --run '${lib.getExe nodejs} dist/server/db/migrate.js' \
      --add-flags dist/server/index.js

    runHook postInstall
  '';

  meta = {
    description = "Meta-aggregation gateway for AI API platforms";
    homepage = "https://github.com/cita-777/metapi";
    license = lib.licenses.mit;
    mainProgram = "metapi";
    platforms = lib.platforms.linux;
  };
})
