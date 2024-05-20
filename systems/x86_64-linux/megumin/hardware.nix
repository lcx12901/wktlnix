{
  modulesPath,
  inputs,
  ...
}: {
  imports = [
    "${modulesPath}/profiles/minimal.nix"
    inputs.nixos-wsl.nixosModules.wsl
  ];

  wsl = {
    enable = true;
    defaultUser = "wktl";
    startMenuLaunchers = true;

    wslConf = {
      automount.root = "/mnt";
      interop.appendWindowsPath = false;
      network.generateHosts = false;
    };

    # Enable integration with Docker Desktop (needs to be installed)
    docker-desktop.enable = false;
  };
}
