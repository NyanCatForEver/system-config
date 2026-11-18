{
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };
  environment.enableAllTerminfo = true;
  programs.mosh.enable = true;

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish = {
      enable = true;
      addresses = true;
    };
  };
  services.resolved.settings.Resolve.MulticastDNS = false;

  services.tailscale.enable = true;
}
