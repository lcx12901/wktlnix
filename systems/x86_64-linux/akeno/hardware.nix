{
  lib,
  pkgs,
  ...
}:
{

  boot = {
    kernelPackages = pkgs.linuxPackages_zen;

    kernelModules = [
      "virtio_balloon"
      "virtio_console"
      "virtio_rng"
    ];

    initrd = {
      availableKernelModules = [
        "virtio_net"
        "virtio_pci"
        "virtio_mmio"
        "virtio_blk"
        "virtio_scsi"
      ];
    };
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
