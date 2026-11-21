{ pkgs, ... }:

{
  hardware.graphics.enable32Bit = true;

  programs.steam.enable = true;
  programs.gamescope.enable = true;

  environment.systemPackages = with pkgs; [
    mangohud
    prismlauncher

    boxflat
  ];
}
