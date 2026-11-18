{ pkgs, ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      geist-font = prev.geist-font.overrideAttrs (
        final': prev': {
          version = "1.9.2";
          srcs = [
            (final.fetchzip {
              url = "https://github.com/vercel/geist-font/releases/download/v${final'.version}/geist-font-v${final'.version}.zip";
              hash = "sha256-BRx+tfFs9lurWWRBeyxe2voO8hnzJUOrLweqb4o4cM8=";
            })
          ];
        }
      );
      googlesans-flex = final.callPackage ../../packages/googlesans-flex.nix { };
    })
  ];

  fonts = {
    packages = with pkgs; [
      geist-font
      googlesans-flex
      googlesans-code
    ];
    fontconfig.defaultFonts = {
      serif = [ "Geist Serif:style=Regular" ];
      sansSerif = [ "Google Sans Flex" ];
      monospace = [ "Google Sans Code" ];
    };
  };

  boot.plymouth.font = "${pkgs.googlesans-flex}/share/fonts/googlesans-flex/GoogleSansFlex[ROND,opsz,slnt,wdth,wght].ttf";
}
