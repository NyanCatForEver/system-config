{ config, private, ... }:

{
  virtualisation.docker.enable = true;

  services.samba = {
    enable = true;
    openFirewall = true;
    settings = {
      global = {
        "security" = "user";
        "use sendfile" = "yes";
        "hosts allow" = "192.168. 127.0.0.1 localhost";
        "hosts deny" = "ALL";
      };
      "public" = {
        "path" = "/data/share/public";
        "read only" = "no";
        "guest ok" = "yes";
      };
      "private" = {
        "path" = "/data/share/private";
        "read only" = "no";
        "guest ok" = "no";
      };
    };
  };

  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };

  services.tailscale.useRoutingFeatures = "server";

  age.secrets.cloudflared-tunnel-credentials.file = ./cloudflared-tunnel-credentials.json.age;

  services.cloudflared = {
    enable = true;
    tunnels."9e4f4df9-1873-4173-9bf9-9ac20d71fa8c" = {
      credentialsFile = config.age.secrets.cloudflared-tunnel-credentials.path;
      default = "http_status:404";
      ingress = private.cloudflared-tunnel-ingress-rules;
    };
  };
}
