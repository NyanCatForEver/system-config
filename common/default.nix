{
  pkgs,
  config,
  hostName,
  ...
}:

{
  imports = [
    ./modules
    ./locale.nix
    ./services.nix
  ];

  networking.hostName = hostName;

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    trusted-public-keys = [
      "fednyan-1:bCiSYyO2TilONdBbhw+ReVT7chkCy/Rkan4hxR6jvA0="
    ];
  };
  nixpkgs.config.allowUnfree = true;

  hardware.enableRedistributableFirmware = true;
  services.fwupd.enable = true;

  services.xserver.xkb.layout = "fr";
  console.useXkbConfig = true;
  services.kmscon.useXkbConfig = true;

  users.users.nyan = {
    description = "Nyan";
    isNormalUser = true;
    extraGroups = [
      "wheel"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE5fOUA77PVAN7hUbaEsj2ihf8hXXoINJu78gJ3pkr7f nyan@nyarch-2025-06-19"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG7MyxmY3jX3tSohvBKSm8Pvz2BO6txw+SLmxGLH1zo6 u0_a440@localhost"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICu8qjIXVv1nFoceKQ4+EcSQUOct6/DlLfrKVXd8s7jo nyan@fedpad"
    ];
    shell = pkgs.fish;
  };

  programs.fish.enable = true;
  programs.nh.enable = true;
  programs.git = {
    enable = true;
    config = {
      init.defaultBranch = "main";
      user = {
        name = "Nyan";
        email = "graphical.target@gmail.com";
        signingkey = "${config.users.users.nyan.home}/.ssh/id_ed25519";
      };
    };
  };
  programs.htop.enable = true;

  environment.variables = {
    EDITOR = "micro";
  };

  environment.systemPackages = with pkgs; [
    micro
    wget
    file
    osc
    killall
    unzip
    pciutils
    usbutils
    dust
    ncdu
    fastfetch

    nvd

    gh
    git-credential-manager
    agenix
  ];
}
