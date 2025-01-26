{
  lib,
  buildNpmPackage,
  fetchurl,
  ...
}:
buildNpmPackage rec {
  pname = "vue-language-server";

  version = "2.2.0";

  src = fetchurl {
    url = "https://registry.npmjs.org/@vue/language-server/-/language-server-${version}.tgz";
    sha256 = "sha256-foWKEhK8YE4ZsbejJUKKPNR+G7ZrJWIPEk/1PVe6YRo=";
  };

  npmDepsHash = "sha256-/Jk6B4OWK46E4Q7W666NH78Gv8iC8slnde4c64dm3xo=";

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
