{
  buildNpmPackage,
  fetchurl,
}:

buildNpmPackage rec {
  pname = "vue-language-server";
  version = "2.2.0";

  src = fetchurl {
    url = "https://registry.npmjs.org/@vue/language-server/-/language-server-${version}.tgz";
    hash = "sha256-foWKEhK8YE4ZsbejJUKKPNR+G7ZrJWIPEk/1PVe6YRo=";
  };

  npmDepsHash = "sha256-zWIczd2OYXzfUALmJpMKtCC1mLugXlXpxIbTP+Db46E=";

  postPatch = ''
    ln -s ${./package-lock.json} package-lock.json
  '';

  dontNpmBuild = true;

}
