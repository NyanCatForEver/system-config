{
  config,
  pkgs,
  lib,
  ...
}:

let
  toggle-app-launcher = pkgs.writeShellApplication {
    name = "toggle-app-launcher";
    runtimeInputs = with pkgs; [
      config.systemd.package
      killall
      jq
      vicinae
      niri
    ];
    text = ''
      if systemctl --user is-active vicinae.service; then
        vicinae toggle
        exit 0
      fi

      if niri msg -j layers | jq -e '.[] | select(.namespace == "launcher")'; then
        killall fuzzel
      else
        fuzzel
      fi
    '';
  };
in
{
  programs.niri = {
    enable = true;
    useNautilus = false;
    package = pkgs.symlinkJoin {
      name = "niri-wrapped";
      paths = [ pkgs.niri ];

      nativeBuildInputs = [ pkgs.makeWrapper ];

      postBuild = ''
        wrapProgram $out/bin/niri-session \
          --set QT_QPA_PLATFORMTHEME qt5ct \
          --set _JAVA_AWT_WM_NONREPARENTING 1
      '';

      passthru = pkgs.niri.passthru;
    };
  };

  xdg.portal.config.niri = lib.mkForce {
    "org.freedesktop.impl.portal.Secret" = [ "oo7-portal" ];
    "org.freedesktop.impl.portal.FileChooser" = [ "kde" ];
  };

  programs.dux-shell = {
    enable = true;
    systemd.target = "niri.service";
  };

  systemd.user.services.wl-clip-persist.wantedBy = [ "niri.service" ];

  environment.systemPackages =
    with pkgs;
    [
      xwayland-satellite

      fuzzel
      toggle-app-launcher

      nwg-look
      gnome-tweaks
      adw-gtk3
      adwaita-icon-theme

      kdePackages.breeze
      qt6Packages.qt6ct-kde
    ]
    ++ lib.optionals config.networking.networkmanager.enable (with pkgs; [ networkmanagerapplet ])
    ++ lib.optionals config.hardware.bluetooth.enable (with pkgs; [ bluetui ]);

  systemd.user.services.wl-clip-persist = {
    description = "Keep Wayland clipboard even after programs close";
    documentation = [ "https://github.com/Linus789/wl-clip-persist" ];
    partOf = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "exec";
      ExecStart = "${lib.getExe pkgs.wl-clip-persist} --clipboard regular --all-mime-type-regex '^(?!x-kde-passwordManagerHint).+'";
      Restart = "on-failure";
    };
  };

  nixpkgs.overlays = [
    (final: prev: {
      qt6Packages = prev.qt6Packages.overrideScope (
        final': prev': {
          qt6ct-kde = prev'.qt6ct.overrideAttrs (prev'': {
            pname = "qt6ct-kde";
            buildInputs = prev''.buildInputs ++ [ final.kdePackages.kiconthemes ];
            patches = (prev''.patches or [ ]) ++ [
              (final.fetchpatch {
                url = "https://github.com/duxlabs-dev/dux-repo/raw/90e2a24a7184f67bc57912e17cb3beee381ed261/distro/fedora/qt6ct-kde/qt6ct-kde-0.11.patch";
                hash = "sha256-HFKqlWvTV/Uh1V2S7sQZqOlIiX/pXWs7JTp1Wq7BkZc=";
              })
            ];
          });
        }
      );
    })
  ];

  environment.etc."xdg/menus/applications.menu".source = pkgs.fetchurl {
    url = "https://invent.kde.org/plasma/plasma-workspace/-/raw/v${pkgs.kdePackages.plasma-workspace.version}/menu/desktop/plasma-applications.menu";
    hash = "sha256-pVvOXRPvpsnhmGEAldOKpOuGJXo2cNSIQidecm5wK/Y=";
  };
}
