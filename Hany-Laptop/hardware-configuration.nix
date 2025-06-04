{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];
  boot = {
    initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "vmd" "nvme" "usb_storage" "sd_mod" "rtsx_usb_sdmmc" ];
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
    ];
    extraModprobeConfig = ''
      options kvmfr static_size_mb=32
    '';
    kernelParams = [
      "intel_iommu=on"
      "iommu=pt"
      "pcie_acs_override=downstream,multifunction"
      "pcie_port_pm=off"
      "split_lock_detect=off"
      "nvidia-drm.modeset=1"
    ];
    extraModulePackages = [
      config.boot.kernelPackages.ddcci-driver
      config.boot.kernelPackages.kvmfr
    ];
    kernelPackages = pkgs.linuxPackages_cachyos;
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

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/1a15f6de-61d8-4321-9437-e2275fcd0608";
      fsType = "ext4";
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/A855-3678";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

    "/home" = {
      device = "/dev/disk/by-uuid/820ff00e-320e-4ce3-b157-e1139779c524";
      fsType = "ext4";
    };

    "/var/lib/flatpak" = {
      device = "/home/flatpak";
      fsType = "none";
      options = [ "bind" ];
    };
  };

  hardware = {
    bumblebee.enable = false;
    nvidia-container-toolkit.enable = true;
    nvidia = {
        package = config.boot.kernelPackages.nvidiaPackages.stable;
        open = true;
        nvidiaSettings = true;
        modesetting.enable = true;
        powerManagement.enable = true;
        powerManagement.finegrained = false;
        dynamicBoost.enable = true;
        prime = {
            sync.enable = true;
            reverseSync.enable = false;
            intelBusId = "PCI:0:2:0";
            nvidiaBusId = "PCI:1:0:0";
        };
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
    steam-hardware.enable = true;
    uinput.enable = true;
    intel-gpu-tools.enable = true;
  };

  networking = {
    useDHCP = lib.mkDefault false;
    networkmanager = {
      enable = true;
    };
    nameservers = [ "8.8.8.8" "8.8.4.4" ];
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  services = {
    xserver.videoDrivers = ["nvidia"];
    undervolt = {
        enable = true;
        coreOffset = -40;
        uncoreOffset = -40;
    };
    udev.extraRules = ''
      SUBSYSTEM=="cpu", ACTION=="add", RUN+="${pkgs.bash}/bin/bash -c 'if grep -q GenuineIntel /proc/cpuinfo; then chmod o+r /sys/class/powercap/intel-rapl:0/energy_uj; fi'"
      SUBSYSTEM=="kvmfr", OWNER="omarhanykasban", GROUP="kvm", MODE="0660"
      SUBSYSTEM=="usb", ATTR{idVendor}=="040b", ATTR{idProduct}=="0897", ACTION=="add", RUN+="/bin/sh -c 'amixer -c headset set PCM 100%% && amixer -c headset set PCM,1 100%% && amixer -c Headset set PCM 100%% && amixer -c Headset set PCM,1 100%%'"
    '';
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
    throttled.enable = true;
    pulseaudio.enable = false;
    tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        CPU_MIN_PERF_ON_AC = 50;
        CPU_MAX_PERF_ON_AC = 100;
      };
    };
  };

  # System packages
  environment.systemPackages = with pkgs; [
    lm_sensors
    pwvucontrol
    networkmanagerapplet
    lact
    acpi
  ];

  systemd.packages = with pkgs; [ lact ];
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
      size = 8192;
    }
  ];
  zramSwap = {
    enable = true;
    memoryPercent = 100;
    priority = 100;
  };

  nixpkgs.config.nvidia.acceptLicense = true;

}