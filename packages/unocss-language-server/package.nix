{
  lib,
  stdenv,
  fetchFromGitHub,
  pnpm,
  nodejs,
  nix-update-script,
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

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 1;
    hash = "sha256-LYsalGuxSHWiEKg3saYhREkSwEr2UaWE71V0qo8Xjzc=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm.configHook
    makeBinaryWrapper
  ];

  buildPhase = ''
    runHook preBuild
    pnpm run build
    runHook postBuild
  '';

  preInstall = ''
    rm -rf node_modules/
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{bin,lib/unocss-language-server}
    cp -r {bin,out} $out/lib/unocss-language-server/
    makeWrapper ${lib.getExe nodejs} $out/bin/unocss-language-server \
          --inherit-argv0 \
          --add-flags $out/lib/unocss-language-server/bin/index.js
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A language server for unocss";
    homepage = "https://github.com/xna00/unocss-language-server#readme";
    changelog = "https://github.com/vuejs/language-tools/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "unocss-language-server";
  };
})
