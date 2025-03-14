{
  lib,
  buildNpmPackage,
  fetchurl,
  ...
}:
buildNpmPackage rec {
  pname = "vue-language-server";

  version = "2.2.8";

  src = fetchurl {
    url = "https://registry.npmjs.org/@vue/language-server/-/language-server-${version}.tgz";
    sha256 = "sha256-bgec/0/QmuDd7Nh+LdYnmb95ss6Hv685Nf7XNONOTcs=";
  };

  npmDepsHash = "sha256-T1/oX6bX2YgpamUdWrXFCNDhV25lWrOCWG/GOLMumzY=";

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
