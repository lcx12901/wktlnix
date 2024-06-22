{
  pkgs,
  modulesPath,
  ...
}: {
  imports = [(modulesPath + "/installer/scan/not-detected.nix")];

  boot = {
    kernelPackages = pkgs.linuxPackages_zen;

    initrd = {
      availableKernelModules = [
        "nvme"
        "xhci_pci"
        "ehci_pci"
        "ahci"
        "usb_storage"
        "usbhid"
        "sd_mod"
        "sr_mod"
      ];
    };
  };

  hardware = {
    enableRedistributableFirmware = true;
  };
}
