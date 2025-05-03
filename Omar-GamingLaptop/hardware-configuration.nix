{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # Boot configuration
  boot = {
    # Kernel modules
    initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
    kernelModules = [
      "kvm-intel"
      "drivetemp"
      "kvmfr"
    ];
    initrd.kernelModules = [
      "vfio"
      "vfio_pci"
      "vfio_iommu_type1"
      "i915"
      "nvidia"
      "nvidia_modeset"
      "nvidia_uvm"
      "nvidia_drm"
      "i2c_nvidia_gpu"
      "nvidia-gpu"
    ];

    # Blacklisted modules
    blacklistedKernelModules = [
      "nouveau"
    ];

    # Additional kernel parameters
    extraModprobeConfig = ''
      options vfio-pci ids=10de:2188,10de:1aeb,10de:1aec,10de:1aed
      options kvmfr static_size_mb=32
    '';

    kernelParams = [
      "intel_iommu=on"
      "iommu=pt"
      "pcie_acs_override=downstream,multifunction"
      "pcie_port_pm=off"
      "split_lock_detect=off"
    ];

    # Additional kernel packages
    extraModulePackages = [
      config.boot.kernelPackages.ddcci-driver
      config.boot.kernelPackages.kvmfr
    ];

    # Kernel configuration
    kernelPackages = pkgs.linuxPackages_cachyos;

    # Bridge STP configuration
    kernel.sysctl = {
      "net.bridge.bridge-nf-call-iptables" = 0;
      "net.bridge.bridge-nf-call-ip6tables" = 0;
      "net.bridge.bridge-nf-call-arptables" = 0;
    };
  };

  # Disable STP for bridge
  systemd.services."bridge-stp" = {
    enable = false;
  };

  # File system configuration
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/8cb6547c-3617-4b73-9f0e-20a7e58b31ba";
      fsType = "ext4";
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/B726-FA27";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

    "/home" = {
      device = "/dev/disk/by-uuid/c59546a3-b39b-4a59-a45f-b2bcd09fd059";
      fsType = "ext4";
    };

    "/mnt/nvme" = {
      device = "/dev/disk/by-uuid/82638c7f-f7d4-49dd-8404-6d8cd667624b";
      fsType = "ext4";
      options = [ "nosuid" "nodev" "nofail" "x-gvfs-show" ];
    };

    "/var/lib/flatpak" = {
      device = "/home/flatpak";
      fsType = "none";
      options = [ "bind" ];
    };
  };

  # Hardware configuration
  hardware = {
    nvidia = {
        package = config.boot.kernelPackages.nvidiaPackages.stable;
        open = true;
        nvidiaSettings = true;
        modesetting.enable = true;
        powerManagement.enable = true;
        powerManagement.finegrained = true;
    };
    sensor.hddtemp = {
      enable = true;
      drives = [ "*" ];
    };
    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

    bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
          Experimental = true;
        };
      };
    };
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    pulseaudio.enable = false;
    steam-hardware.enable = true;
    uinput.enable = true;
  };

  # Networking configuration
  networking = {
    useDHCP = lib.mkDefault false;
    networkmanager = {
      enable = true;
    };
    nameservers = [ "8.8.8.8" "8.8.4.4" ];
  };

  # Nixpkgs configuration
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  # System services and packages
  services = {
    udev.extraRules = ''
      SUBSYSTEM=="kvmfr", OWNER="omarhanykasban", GROUP="kvm", MODE="0660"
      SUBSYSTEM=="usb", ATTR{idVendor}=="040b", ATTR{idProduct}=="0897", ACTION=="add", RUN+="/bin/sh -c 'amixer -c headset set PCM 100% && amixer -c headset set PCM,1 100% && amixer -c Headset set PCM 100% && amixer -c Headset set PCM,1 100%'"
    '';
    input-remapper = {
      enable = true;
      enableUdevRules = true;
    };
    asusd = {
        enable = true;
        enableUserService = true;
    };
    fwupd.enable = true;
    pipewire = {
      enable = true;
      pulse.enable = true;
      wireplumber.enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
    };
    blueman.enable = true;
    throttled.enable = true;
  };

  # System packages
  environment.systemPackages = with pkgs; [
    lm_sensors
    pwvucontrol
    networkmanagerapplet
  ];

  # Programs configuration
  programs = {
    coolercontrol.enable = true;
    nm-applet.enable = true;
  };

  # Swap configuration
  swapDevices = [
    {
      device = "/swapfile";
      size = 32768;
    }
  ];
  zramSwap = {
    enable = true;
    memoryPercent = 100;
    priority = 100;
  };
}
