{ modulesPath, ... }:
{
  imports = [
    "${modulesPath}/profiles/minimal.nix"
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

  documentation.man.enable = true;
}
