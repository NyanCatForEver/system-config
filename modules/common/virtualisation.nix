{
  virtualisation.libvirtd = {
    enable = true;
    qemu.swtpm.enable = true;
  };
  programs.virt-manager.enable = true;

  users.users.nyan.extraGroups = [ "libvirtd" ];
}
