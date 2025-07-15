{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  # Boot configuration
  boot = {
    initrd = {
      availableKernelModules = [
        "ahci"
        "xhci_pci"
        "virtio_pci"
        "virtio_scsi"
        "usb_storage"
        "sd_mod"
        "virtio_blk"
      ];
      kernelModules = [ ];
    };
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];
  };

  # File systems
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/b7253bc9-e8fa-4d92-b882-aabcbdc28edf";
      fsType = "ext4";
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/E553-7CA6";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

    "/home" = {
      device = "/dev/disk/by-uuid/57e5048a-7743-4eb6-b9f3-e5d4adb803b9";
      fsType = "ext4";
    };

    "/mnt/Omar-PC" = {
      device = "//192.168.1.14/omar-pc";
      fsType = "cifs";
      options = [
        "username=omarhanykasban"
        "password=omargamer1234"
        "uid=1000"
        "gid=1000"
        "iocharset=utf8"
        "vers=3.0"
        "rw"
        "nofail"
        "x-systemd.automount"
      ];
    };
  };

  # Swap configuration
  swapDevices = [ ];

  # Networking
  networking = {
    useDHCP = lib.mkDefault false;
    networkmanager = {
      enable = true;
    };
    interfaces.enp1s0 = {
      ipv4 = {
        addresses = [{
          address = "192.168.1.16";
          prefixLength = 24;
        }];
        routes = [{
          address = "0.0.0.0";
          prefixLength = 0;
          via = "192.168.1.1";
        }];
      };
    };
    nameservers = [ "192.168.1.116" "8.8.8.8" ];
  };

  # Platform configuration
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
