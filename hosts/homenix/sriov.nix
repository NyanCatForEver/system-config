{ pkgs, ... }:

{
  boot = {
    extraModulePackages = with pkgs; [ xe-sriov ];
    blacklistedKernelModules = [ "i915" ];

    kernelModules = [ "vfio-pci" ];
    kernelParams = [ "intel_iommu=on" ];
    extraModprobeConfig = "options xe max_vfs=7 force_probe=4690";
  };

  systemd.tmpfiles.rules = [ "w /sys/devices/pci0000:00/0000:00:02.0/sriov_numvfs - - - - 7" ];

  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="pci", KERNEL=="0000:00:02.[1-7]", ATTR{vendor}=="0x8086", ATTR{device}=="0x4690", DRIVER!="vfio-pci", RUN+="/bin/sh -c 'echo \$kernel > /sys/bus/pci/devices/\$kernel/driver/unbind; echo vfio-pci > /sys/bus/pci/devices/\$kernel/driver_override; modprobe vfio-pci; echo \$kernel > /sys/bus/pci/drivers/vfio-pci/bind'"
  '';
}
