{
  buildNpmPackage,
  fetchurl,
}:

buildNpmPackage rec {
  pname = "vue-language-server";
  version = "2.1.10";

  src = fetchurl {
    url = "https://registry.npmjs.org/@vue/language-server/-/language-server-${version}.tgz";
    hash = "sha256-xf8EzFGNelC0ebW2jYUBWBZ/tYUHMenv1WlGbpvIVhY=";
  };

  npmDepsHash = "sha256-81JY2VKH9fVfUwAW3+119mEOmanoWdfR5Dkp11sWM1g=";

  postPatch = ''
    ln -s ${./package-lock.json} package-lock.json
  '';

  dontNpmBuild = true;

}
