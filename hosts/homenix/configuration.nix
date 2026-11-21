{
  pkgs,
  modules,
  ...
}:

{
  imports =
    modules "common" [
      "virtualisation.nix"
      "networkd.nix"
      "networkd-bridge.nix"
    ]
    ++ [
      ./services.nix
      ./sriov.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_6_18;

  fileSystems = {
    "/".options = [ "compress=zstd" ];
    "/nix".options = [
      "compress=zstd"
      "noatime"
    ];
  };

  boot.tmp.useTmpfs = true;
  swapDevices = [
    {
      device = "/swap/swapfile";
      size = 32 * 1024;
    }
  ];

  time.timeZone = "Europe/Paris";

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [ vpl-gpu-rt ];
  };

  virtualisation.libvirtd.qemu.package = pkgs.qemu_kvm;

  system.stateVersion = "25.11";
}
