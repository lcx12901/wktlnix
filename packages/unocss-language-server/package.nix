{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpm,
  nodejs,
  makeBinaryWrapper,
  ...
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "unocss-language-server";
  version = "0.1.8";

  src = fetchFromGitHub {
    owner = "xna00";
    repo = "unocss-language-server";
    rev = "v${finalAttrs.version}";
    hash = "sha256-rRi9JvjljvjBbY6UsH2YzAQcp+Z+MqxK7hhDNkpEANw=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 1;
    hash = "sha256-LYsalGuxSHWiEKg3saYhREkSwEr2UaWE71V0qo8Xjzc=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm
    pnpmConfigHook
    makeBinaryWrapper
  ];

  buildPhase = ''
    runHook preBuild
    pnpm run build
    runHook postBuild
  '';

  preInstall = ''
    CI=true pnpm prune --prod

    # remove non-deterministic files
    rm node_modules/.modules.yaml node_modules/.pnpm-workspace-state-v1.json
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{bin,lib/unocss-language-server}
    cp -r {bin,out,node_modules} $out/lib/unocss-language-server/
    makeWrapper ${lib.getExe nodejs} $out/bin/unocss-language-server \
          --inherit-argv0 \
          --add-flags $out/lib/unocss-language-server/bin/index.js
    runHook postInstall
  '';
})
