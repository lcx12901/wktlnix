{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.types) enum;
  inherit (lib.${namespace}) mkBoolOpt mkOpt enabled;

  inherit (config.${namespace}) user;

  cfg = config.${namespace}.virtualisation.kvm;
in
{
  options.${namespace}.virtualisation.kvm = {
    enable = mkBoolOpt false "Whether or not to enable KVM virtualisation.";
    platform = mkOpt (enum [
      "amd"
      "intel"
    ]) "intel" "Which CPU platform the machine is using.";
  };

  config = mkIf cfg.enable {
    boot = {
      kernelModules = [
        "kvm-${cfg.platform}"
        "vfio"
        "vfio_iommu_type1"
        "vfio_pci"
      ];

      kernelParams = [
        "${cfg.platform}_iommu=on"
        "${cfg.platform}_iommu=pt"
        "kvm.ignore_msrs=1"
      ];
    };

    programs.virt-manager = enabled;

    # trust bridge network interface(s)
    networking.firewall.trustedInterfaces = [ "virbr0" ];

    virtualisation = {
      libvirtd = {
        enable = true;
        extraConfig = ''
          user="${user.name}"
        '';

        onBoot = "ignore";
        onShutdown = "shutdown";

        qemu = {
          package = pkgs.qemu_kvm;
          ovmf = enabled;
          swtpm.enable = true;

          verbatimConfig = ''
            namespaces = []
            user = "+${builtins.toString config.users.users.${user.name}.uid}"
          '';

          vhostUserPackages = [ pkgs.virtiofsd ];
        };
      };

      spiceUSBRedirection.enable = true;
    };

    wktlnix = {
      user = {
        extraGroups = [
          "disk"
          "input"
          "kvm"
          "libvirtd"
          "qemu-libvirtd"
        ];
      };
    };

    environment.persistence."/persist" = {
      hideMounts = true;

      directories = [ "/var/lib/libvirt" ];
    };
  };
}
