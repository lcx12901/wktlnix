{
  lib,
  buildNpmPackage,
  fetchurl,
  ...
}:
buildNpmPackage rec {
  pname = "vue-language-server";

  version = "2.2.2";

  src = fetchurl {
    url = "https://registry.npmjs.org/@vue/language-server/-/language-server-${version}.tgz";
    sha256 = "sha256-lQvyGh3mvw7VjKDdNYyY1v2kL6tYSiOWD7DBax21BZQ=";
  };

  npmDepsHash = "sha256-3FxO/kArqGFmpBMiQIklP0iSGux4mMnXAu/XHzwdrlM=";

  postPatch = ''
    ln -s ${./package-lock.json} package-lock.json
  '';

  dontNpmBuild = true;

  meta = {
    description = "Official Vue.js language server";
    homepage = "https://github.com/vuejs/language-tools#readme";
    changelog = "https://github.com/vuejs/language-tools/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lcx12901 ];
    mainProgram = "vue-language-server";
  };
}
