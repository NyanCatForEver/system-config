{
  pkgs,
  modules,
  ...
}:

{
  imports =
    modules "common" [
      "networkmanager.nix"
      "virtualisation.nix"
    ]
    ++ modules "desktop" [
      "android-mic.nix"
      "common.nix"
      "development.nix"
      "dux-greeter.nix"
      "fonts.nix"
      "gaming.nix"
      "niri.nix"
      "plasma.nix"
    ];

  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 5;
    extraEntries = {
      "fedora.conf" = ''
        title Fedora
        efi /EFI/fedora/shim.efi
        sort-key x_fedora
      '';
      "opencore.conf" = ''
        title OpenCore
        efi /EFI/OC/OpenCore.efi
        sort-key y_opencore
      '';
      "chrome.conf" = ''
        title ChromeOS
        efi /EFI/chrome/grubx64.efi.efi
        sort-key z_chrome
      '';
    };
  };
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  fileSystems = {
    "/".options = [ "compress=zstd" ];
    "/home".options = [ "compress=zstd" ];
    "/nix".options = [
      "compress=zstd"
      "noatime"
    ];
  };

  hardware.graphics.extraPackages = with pkgs; [ intel-media-driver ];
  boot.kernelParams = [ "i915.enable_guc=3" ];

  hardware.bluetooth.enable = true;

  services.kmscon.config.font-size = 24;

  services.displayManager.dux-greeter.compositor.customConfig = ''
    output "eDP-1" { scale 1.25; }
  '';

  programs.java.symlink = {
    enable = true;
    packages = {
      openjdk-8 = "${pkgs.openjdk8}/lib/openjdk";
      openjdk-25 = "${pkgs.openjdk25}/lib/openjdk";
    };
  };

  system.stateVersion = "26.11";
}
