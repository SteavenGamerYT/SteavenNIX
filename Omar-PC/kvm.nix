{ config, lib, pkgs, ... }:
{
  # Enable virt-manager GUI
  programs.virt-manager.enable = true;

  # Add user to libvirtd group
  users.groups.libvirtd.members = ["omarhanykasban"];

  # Main libvirtd configuration
  virtualisation.libvirtd = {
    enable = true;
    qemu.swtpm.enable = true;
  };

  # QEMU verbatim configuration
  virtualisation.libvirtd.qemu.verbatimConfig = ''
    cgroup_device_acl = [
      "/dev/null",
      "/dev/full",
      "/dev/zero",
      "/dev/random",
      "/dev/urandom",
      "/dev/ptmx",
      "/dev/kvm",
      "/dev/kvmfr0",
      "/dev/rtc",
      "/dev/hpet"
    ]
  '';
}
