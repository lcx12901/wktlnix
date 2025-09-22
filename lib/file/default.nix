{ inputs }:
let
  inherit (inputs.nixpkgs.lib)
    last
    genAttrs
    filterAttrs
    mapAttrsToList
    hasPrefix
    foldl'
    flatten
    ;
  file-name-regex = "(.*)\\.(.*)$";

  is-file-kind = kind: kind == "regular";
  is-directory-kind = kind: kind == "directory";

  ## Map and flatten an attribute set into a list.
  ## Example Usage:
  ## ```nix
  ## map-concat-attrs-to-list (name: value: [name value]) { x = 1; y = 2; }
  ## ```
  ## Result:
  ## ```nix
  ## [ "x" 1 "y" 2 ]
  ## ```
  #@ (a -> b -> [c]) -> Attrs -> [c]
  map-concat-attrs-to-list = f: attrs: flatten (mapAttrsToList f attrs);
in
rec {
  ## Check if a file name has a file extension.
  ## Example Usage:
  ## ```nix
  ## has-any-file-extension "my-file.txt"
  ## ```
  ## Result:
  ## ```nix
  ## true
  ## ```
  #@ String -> Bool
  has-any-file-extension =
    file:
    let
      match = builtins.match file-name-regex (toString file);
    in
    match != null;

  ## Get the file extension of a file name.
  ## Example Usage:
  ## ```nix
  ## get-file-extension "my-file.final.txt"
  ## ```
  ## Result:
  ## ```nix
  ## "txt"
  ## ```
  #@ String -> String
  get-file-extension =
    file:
    if has-any-file-extension file then
      let
        match = builtins.match file-name-regex (toString file);
      in
      last match
    else
      "";

  ## Check if a file name has a specific file extension.
  ## Example Usage:
  ## ```nix
  ## has-file-extension "txt" "my-file.txt"
  ## ```
  ## Result:
  ## ```nix
  ## true
  ## ```
  #@ String -> String -> Bool
  has-file-extension =
    extension: file:
    if has-any-file-extension file then extension == get-file-extension file else false;

  ## Safely read from a directory if it exists.
  ## Example Usage:
  ## ```nix
  ## safe-read-directory ./some/path
  ## ```
  ## Result:
  ## ```nix
  ## { "my-file.txt" = "regular"; }
  ## ```
  #@ Path -> Attrs
  safe-read-directory = path: if builtins.pathExists path then builtins.readDir path else { };

  get-file = path: "${./../..}/${path}";

  ## Get files at a given path.
  ## Example Usage:
  ## ```nix
  ## get-files ./something
  ## ```
  ## Result:
  ## ```nix
  ## [ "./something/a-file" ]
  ## ```
  #@ Path -> [Path]
  get-files =
    path:
    mapAttrsToList (name: _: "${path}/${name}") (
      filterAttrs (_: kind: kind == "regular") (safe-read-directory path)
    );

  ## Get files at a given path, traversing any directories within.
  ## Example Usage:
  ## ```nix
  ## get-files-recursive ./something
  ## ```
  ## Result:
  ## ```nix
  ## [ "./something/some-directory/a-file" ]
  ## ```
  #@ Path -> [Path]
  get-files-recursive =
    path:
    let
      entries = safe-read-directory path;
      filtered-entries = filterAttrs (
        _name: kind: (is-file-kind kind) || (is-directory-kind kind)
      ) entries;
      map-file =
        name: kind:
        let
          path' = "${path}/${name}";
        in
        if is-directory-kind kind then get-files-recursive path' else path';
      files = map-concat-attrs-to-list map-file filtered-entries;
    in
    files;

  ## Get nix files at a given path named "default.nix", traversing any directories within.
  ## Example Usage:
  ## ```nix
  ## get-default-nix-files-recursive "./something"
  ## ```
  ## Result:
  ## ```nix
  ## [ "./something/some-directory/default.nix" ]
  ## ```
  #@ Path -> [Path]
  get-default-nix-files-recursive =
    path: builtins.filter (name: builtins.baseNameOf name == "default.nix") (get-files-recursive path);

  ## Get nix files at a given path not named "default.nix".
  ## Example Usage:
  ## ```nix
  ## get-non-default-nix-files "./something"
  ## ```
  ## Result:
  ## ```nix
  ## [ "./something/a.nix" ]
  ## ```
  #@ Path -> [Path]
  get-non-default-nix-files =
    path:
    builtins.filter (
      name: (has-file-extension "nix" name) && (builtins.baseNameOf name != "default.nix")
    ) (get-files path);

  ## Get nix files at a given path not named "default.nix", traversing any directories within.
  ## Example Usage:
  ## ```nix
  ## get-non-default-nix-files-recursive "./something"
  ## ```
  ## Result:
  ## ```nix
  ## [ "./something/some-directory/a.nix" ]
  ## ```
  #@ Path -> [Path]
  get-non-default-nix-files-recursive =
    path:
    builtins.filter (
      name: (has-file-extension "nix" name) && (builtins.baseNameOf name != "default.nix")
    ) (get-files-recursive path);

  # Recursively parse systems directory structure
  parseSystemConfigurations =
    systemsPath:
    let
      systemArchs = builtins.attrNames (builtins.readDir systemsPath);

      generateSystemConfigs =
        system:
        let
          systemPath = systemsPath + "/${system}";
          hosts = builtins.attrNames (builtins.readDir systemPath);
        in
        genAttrs hosts (hostname: {
          inherit system hostname;
          path = systemPath + "/${hostname}";
        });
    in
    foldl' (acc: system: acc // generateSystemConfigs system) { } systemArchs;

  # Parse homes directory structure for home configurations
  parseHomeConfigurations =
    homesPath:
    let
      systemArchs = builtins.attrNames (builtins.readDir homesPath);

      generateHomeConfigs =
        system:
        let
          systemPath = homesPath + "/${system}";
          userAtHosts = builtins.attrNames (builtins.readDir systemPath);

          parseUserAtHost =
            userAtHost:
            let
              # Split "username@hostname" into parts
              parts = builtins.split "@" userAtHost;
              username = builtins.head parts;
              hostname = builtins.elemAt parts 2; # After split: [username, "@", hostname]
            in
            {
              inherit
                system
                username
                hostname
                userAtHost
                ;
              path = systemPath + "/${userAtHost}";
            };
        in
        genAttrs userAtHosts parseUserAtHost;
    in
    foldl' (acc: system: acc // generateHomeConfigs system) { } systemArchs;

  # Filter systems for NixOS (Linux)
  filterNixOSSystems =
    systems:
    filterAttrs (
      _name: { system, ... }: hasPrefix "x86_64-linux" system || hasPrefix "aarch64-linux" system
    ) systems;
}
