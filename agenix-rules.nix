let
  systems = {
    nixyan = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKuTiSQe0yXOLqgKHNBcmz2VHwUChrqmT/8jH+/nzw16 root@nixyan";
    nixpad = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAkfkDI9CF28kJqKsR/I4XHajmA95sdMbHJKgkuCjl+s root@nixpad";
    homenix = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPqeBq1D3NF3hgAGX7skoxBwIa7thp57IYDryB/hF0Oi root@homenix";
  };
  users = {

  };
  allUsers = builtins.attrValues users;
  allSystems = builtins.attrValues systems;

  hostSecrets =
    hostName: secrets:
    builtins.listToAttrs (
      map (secret: {
        name = "hosts/${hostName}/${secret}";
        value.publicKeys = [ systems.${hostName} ];
      }) secrets
    );
in
{

}
// hostSecrets "homenix" [ "cloudflared-tunnel-credentials.json.age" ]
// hostSecrets "nixyan" [ "nix-secret-key.age" ]
