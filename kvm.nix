{ config, lib, pkgs, ... }:
{

programs.virt-manager.enable = true;

users.groups.libvirtd.members = ["omarhanykasban"];

virtualisation.spiceUSBRedirection.enable = true;
virtualisation.libvirtd = {
  enable = true;
  qemu.swtpm.enable = true;
  };
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
