{ config, lib, pkgs, unstable, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/profiles/qemu-guest.nix")
    ];
  boot = {
    initrd.availableKernelModules = [ "ahci" "ohci_pci" "ehci_pci" "usb_storage" "usbhid" "sd_mod" "sr_mod" ];
    kernelModules = [
      "kvm-amd"
      "drivetemp"
      "smsc47b397"
    ];
    initrd.kernelModules = [
      "drm_kms_helper"
      "amdgpu"
    ];

    # Additional kernel parameters
    extraModprobeConfig = ''
      options amdgpu ppfeaturemask=0xFFFFFFFF
      options amdgpu si_support=1 cik_support=1
      options radeon si_support=0 cik_support=0
    '';

    kernelParams = [
      "pcie_port_pm=off"
      "split_lock_detect=off"
      "clearcpuid=514"
      "usbcore.autosuspend=-1"
      "drm.edid_firmware=DVI-I-1:edid/custom-edid.bin"
      "video=DVI-I-1:1440x900@60"
    ];

    blacklistedKernelModules = [
      "radeon"
    ];

    # Bridge STP configuration
    kernel.sysctl = {
      "net.bridge.bridge-nf-call-iptables" = 0;
      "net.bridge.bridge-nf-call-ip6tables" = 0;
      "net.bridge.bridge-nf-call-arptables" = 0;
    };
  };

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/42981266-4ba1-406b-beb5-b0c4ac6a44e8";
      fsType = "ext4";
    };
  fileSystems."/mnt/windows10" =
    { device = "/dev/disk/by-uuid/B66C280F6C27C947";
      fsType = "ntfs3";
      options = [ "nosuid" "nodev" "nofail" "x-gvfs-show" "uid=1000" "gid=1000" "rw" "exec" "umask=000" "windows_names"];
    };

  hardware = {
    enableRedistributableFirmware = true;
    display = {
        edid.enable = true;
        outputs."DVI-I-1".edid = "custom-edid.bin";
        edid.modelines = {
            "1280x1024_75" = "135.00 1280 1296 1440 1688 1024 1025 1028 1066 +hsync +vsync";
            "1440x900_60"  = "106.50 1440 1528 1672 1904 900 903 909 934 -hsync +vsync";
        };
    };
  };

  services = {
    udev.extraRules = ''
      SUBSYSTEM=="cpu", ACTION=="add", RUN+="${pkgs.bash}/bin/bash -c 'chmod o+r /sys/class/powercap/intel-rapl:0/energy_uj'"
    '';
    input-remapper = {
      enable = true;
      enableUdevRules = true;
    };
    pipewire = {
      enable = true;
      pulse.enable = true;
      wireplumber.enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
    };
    pulseaudio.enable = false;
    xserver.videoDrivers = [ "amdgpu" ];
  };

  environment.systemPackages = with pkgs; [
    lm_sensors
    pwvucontrol
    networkmanagerapplet
    unstable.lact
    mesa-demos
    nvtopPackages.amd
    pciutils
  ];

  networking = {
    useDHCP = lib.mkDefault true;
    networkmanager.enable = true;
    nameservers = [ "8.8.8.8" "8.8.4.4" ];
  };

  programs = {
    coolercontrol.enable = true;
    nm-applet.enable = true;
  };

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
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}