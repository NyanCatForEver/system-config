{ pkgs, ... }:

{
  boot.plymouth.enable = true;
  boot.kernelParams = [
    "quiet"
    "rd.udev.log_level=3"
    "rd.systemd.show_status=auto"
  ];

  services.kmscon = {
    enable = true;
    config = {
      libseat = true;
      hwaccel = true;
    };
  };

  services.oo7.enable = true;
  programs.git.config.credential.credentialStore = "secretservice";

  services.flatpak.enable = true;
  programs.nix-ld.enable = true;
  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
  };

  services.printing.enable = true;
  hardware.sane.enable = true;

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

  services.locate.enable = true;
  programs.nix-index.enable = true;
  programs.command-not-found.enable = false;

  programs.obs-studio.enable = true;

  environment.variables = {
    TERMINAL = "ghostty";
  };

  environment.systemPackages = with pkgs; [
    ghostty
    vicinae
    
    kdePackages.dolphin
    kdePackages.ark
    kdePackages.keepsecret
    kdePackages.filelight
    qview
    haruna
    pavucontrol
    mission-center

    localsend
    thunderbird
    (helium.override {
      commandLineArgs = "--password-store=gnome-libsecret";
    })
    bitwarden-desktop
    vesktop

    wl-clipboard

    imagemagick
    ffmpeg

    android-tools
    scrcpy
  ];

  nixpkgs.overlays = [
    (final: prev: {
      nix-index-unwrapped = prev.nix-index-unwrapped.overrideAttrs (prev': {
        patches = (prev'.patches or [ ]) ++ [
          (prev.fetchpatch {
            url = "https://github.com/NixOS/nix-index/pull/333.patch";
            hash = "sha256-IduMirPAmFfs76YAvp4Nv/W/AS5zJ7zn9lh43F+H2tE=";
          })
        ];
      });
    })
  ];
}
