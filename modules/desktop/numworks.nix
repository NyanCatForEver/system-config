{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    dfu-util
    openocd
  ];

  services.udev.packages = with pkgs; [
    numworks-udev-rules
    openocd
  ];

  users.groups.plugdev = { };
  users.users.nyan.extraGroups = [
    "dialout"
    "plugdev"
  ];
}
