{
  pkgs,
  config,
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

  age.secrets.nix-secret-key.file = ./nix-secret-key.age;
  nix.settings.secret-key-files = config.age.secrets.nix-secret-key.path;

  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 5;
    extraEntries = {
      "fedora.conf" = ''
        title Fedora
        efi /EFI/fedora/shim.efi
        sort-key y_fedora
      '';
      "opencore.conf" = ''
        title OpenCore
        efi /EFI/OC/OpenCore.efi
        sort-key z_opencore
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

  boot.plymouth.extraConfig = ''
    UseSimpledrm=1
    DeviceScale=2
  '';

  environment.systemPackages = with pkgs; [ amdgpu_top ];
  services.lact.enable = true;
  hardware.amdgpu.overdrive.enable = true;

  services.kmscon.config.font-size = 32;

  system.stateVersion = "26.11";
}
