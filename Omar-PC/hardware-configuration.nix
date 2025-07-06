{ config, lib, pkgs, unstable, modulesPath, ... }:

{
  nixpkgs.overlays = [
    (import ./overlays/kmod-override.nix)
  ];
  
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # Boot configuration
  boot = {
    # Kernel modules
    initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
    kernelModules = [
      "kvm-amd"
      "it87"
      "zenpower"
      "drivetemp"
      "kvmfr"
      "pcspkr"
    ];
    initrd.kernelModules = [
      "vfio"
      "vfio_pci"
      "vfio_iommu_type1"
      "amdgpu"
    ];

    # Blacklisted modules
    blacklistedKernelModules = [
      "nvidia"
      "nvidia_modeset"
      "nvidia_uvm"
      "nvidia_drm"
      "i2c_nvidia_gpu"
      "nvidia-gpu"
      "nouveau"
      "k10temp"
    ];

    # Additional kernel parameters
    extraModprobeConfig = ''
      options amdgpu ppfeaturemask=0xFFFFFFFF
      options vfio-pci ids=10de:2188,10de:1aeb,10de:1aec,10de:1aed,1912:0014,c0a9:540a,1c5c:174a
      options kvmfr static_size_mb=32
    '';

    kernelParams = [
      "amd_iommu=on"
      "iommu=pt"
      "pcie_acs_override=downstream,multifunction"
      "pcie_port_pm=off"
      "split_lock_detect=off"
      "clearcpuid=514"
      "video=HDMI-A-1:1920x1080@60"
      "video=HDMI-A-2:1366x768@60"
      "usbcore.autosuspend=-1"
    ];

    # Additional kernel packages
    extraModulePackages = [
      config.boot.kernelPackages.ddcci-driver
      config.boot.kernelPackages.it87
      config.boot.kernelPackages.zenpower
      config.boot.kernelPackages.zenergy
      config.boot.kernelPackages.kvmfr
    ];

    # Kernel configuration
    kernelPackages = pkgs.linuxPackages_cachyos;
    kernelPatches = [
      {
        name = "disable-it87";
        patch = ./disable-it87.patch;
      }
      {
        name = "disable-gpus";
        patch = ./disable-gpus.patch;
      }
    ];

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
      device = "/dev/disk/by-uuid/e625d2b3-8bdf-4e0a-9433-a794e244a7ae";
      fsType = "ext4";
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/5CB5-7DAF";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

    "/home" = {
      device = "/dev/disk/by-uuid/eb2d40ec-fd65-48ba-a271-d99caaca162c";
      fsType = "ext4";
    };

    "/mnt/nvme" = {
      device = "/dev/disk/by-uuid/46fc36ed-0ab2-44da-ba18-02ea90fb2c01";
      fsType = "ext4";
      options = [ "nosuid" "nodev" "nofail" "x-gvfs-show" ];
    };

    "/mnt/hdd" = {
      device = "/dev/disk/by-uuid/2f47ccca-365a-4b47-999b-0f9a91dd8c0e";
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
    sensor.hddtemp = {
      enable = true;
      drives = [ "*" ];
    };
    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    amdgpu = {
      opencl.enable = true;
    };
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
      extraPackages = with pkgs; [
        rocmPackages.clr.icd
      ];
    };
    steam-hardware.enable = true;
    uinput.enable = true;
  };

  # Networking configuration
  networking = {
    useDHCP = lib.mkDefault false;
    networkmanager = {
      enable = true;
      ethernet.macAddress = "fe80::af3f:e416:454d:2c30/64";
    };
    bridges = {
      br0 = {
        interfaces = [ "enp6s0" ];
      };
    };
    interfaces.br0 = {
      ipv4 = {
        addresses = [{
          address = "192.168.1.14";
          prefixLength = 24;
        }];
        routes = [{
          address = "0.0.0.0";
          prefixLength = 0;
          via = "192.168.1.1";
        }];
      };
      ipv6 = {
        addresses = [{
          address = "fe80::af3f:e416:454d:2c30";
          prefixLength = 64;
        }];
      };
    };
    nameservers = [ "8.8.8.8" "8.8.4.4" ];
  };

  # Nixpkgs configuration
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  # System services and packages
  services = {
    udev.extraRules = ''
      SUBSYSTEM=="kvmfr", OWNER="omarhanykasban", GROUP="kvm", MODE="0660"
      SUBSYSTEM=="usb", ATTR{idVendor}=="040b", ATTR{idProduct}=="0897", ACTION=="add", RUN+="/bin/sh -c 'amixer -c headset set PCM 100%% && amixer -c headset set PCM,1 100%% && amixer -c Headset set PCM 100%% && amixer -c Headset set PCM,1 100%%'"
    '';
    xserver.config = ''
      Section "Monitor"
          Identifier "HDMI-0"
          Option "PreferredMode" "1920x1080"
          Option "Position" "0 768"
          Option "Primary" "true"
          Option "Rotate" "normal"
          Option "TargetRefresh" "60"
      EndSection

      Section "Monitor"
          Identifier "HDMI-1"
          Option "PreferredMode" "1366x768"
          Option "Position" "0 0"
          Option "Rotate" "normal"
          Option "TargetRefresh" "60"
      EndSection
    '';
    hardware.openrgb.enable = true;
    input-remapper = {
      enable = true;
      enableUdevRules = true;
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
    printing = {
      enable = true;
      drivers = [ pkgs.hplipWithPlugin ]; 
    };
    pulseaudio.enable = false;
    xserver.videoDrivers = [ "amdgpu" ];
  };

  # System packages
  environment.systemPackages = with pkgs; [
    lm_sensors
    pwvucontrol
    networkmanagerapplet
    unstable.lact
    hplipWithPlugin
    system-config-printer
    gnome-firmware
    clinfo
    efibootmgr
    ollama-rocm
    beep
  ];

  systemd.packages = with pkgs; [ unstable.lact ];
  systemd.services.lactd.wantedBy = ["multi-user.target"];

  # Programs configuration
  programs = {
    coolercontrol.enable = true;
    nm-applet.enable = true;
  };

  # Swap configuration
  swapDevices = [
    {
      device = "/swapfile";
      size = 49152;
    }
  ];
  zramSwap = {
    enable = true;
    memoryPercent = 100;
    priority = 100;
  };
}
