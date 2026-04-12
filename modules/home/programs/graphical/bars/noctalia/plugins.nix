{ lib, ... }:
{
  programs.noctalia-shell = {
    plugins =
      let
        sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";

        mkPlugins =
          pluginNames:
          lib.listToAttrs (
            map (name: {
              inherit name;
              value = {
                inherit sourceUrl;
                enabled = true;
              };
            }) pluginNames
          );
      in
      {
        version = 2;
        sources = [
          {
            enabled = true;
            name = "Noctalia Plugins";
            url = sourceUrl;
          }
        ];
        states = mkPlugins [
          "clipper"
          "catwalk"
        ];
      };

    pluginSettings = {
      catwalk = {
        minimumThreshold = 25;
        hideBackground = true;
      };
    };
  };
}
