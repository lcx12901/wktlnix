{ channels, ... }:
_final: _prev: {
  inherit (channels.nixpkgs-master) vimPlugins vue-language-server;
}
