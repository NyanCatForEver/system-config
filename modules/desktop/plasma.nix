{ pkgs, lib, ... }:

{
  services.desktopManager.plasma6.enable = true;
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    kate
    elisa
    gwenview
    khelpcenter
  ];
  programs.kde-pim.enable = false;

  xdg.portal.config.kde = {
    "org.freedesktop.impl.portal.Secret" = lib.mkForce [ "oo7-portal" ];
  };
}
