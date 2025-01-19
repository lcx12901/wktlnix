{
  mkShell,
  inputs,
  pkgs,
  system,
  ...
}:
let
  inherit (inputs) ags;

  asuna = ags.lib.bundle {
    inherit pkgs;
    name = "asuna"; # name of executable
    src = ../../packages/ags;
    entry = "app.ts";
    gtk4 = true;

    # additional libraries and executables to add to gjs' runtime
    extraPackages = [
      # ags.packages.${system}.battery
      # pkgs.fzf
    ];
  };
in
mkShell {
  packages = [
    asuna
    ags.packages.${system}.default
    pkgs.astal.gjs
  ];

  shellHook = ''

    echo 🔨 AGS DevShell


  '';
}
