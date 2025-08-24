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

    programs.virt-manager = enabled;

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

    # trust bridge network interface(s)
    networking.firewall.trustedInterfaces = [ "virbr0" ];

    systemd.services.libvirt-default-network = {
      description = "Start libvirt default network";
      after = [ "libvirtd.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${pkgs.libvirt}/bin/virsh net-start default";
        ExecStop = "${pkgs.libvirt}/bin/virsh net-destroy default";
        User = "root";
      };
    };

    programs.dconf = {
      enable = true;

      profiles.user.databases = [
        {
          lockAll = true;
          settings = with lib.gvariant; {
            "org/virt-manager/virt-manager/connections" = {
              autoconnect = [ "qemu:///system" ];
              uris = [ "qemu:///system" ];
            };
            "org/virt-manager/virt-manager" = {
              xmleditor-enabled = true;
            };
            "org/virt-manager/virt-manager/console" = {
              resize-guest = mkInt32 1;
              scaling = mkInt32 0;
            };
            "org/virt-manager/virt-manager/stats" = {
              enable-memory-poll = true;
              enable-disk-poll = true;
              enable-net-poll = true;
            };
            "org/virt-manager/virt-manager/vmlist-fields" = {
              host-cpu-usage = true;
              memory-usage = true;
              disk-usage = true;
              network-traffic = true;
            };
          };
        }
      ];
    };

    environment.persistence."/persist" = {
      hideMounts = true;

      directories = [ "/var/lib/libvirt" ];
    };
  };
}
