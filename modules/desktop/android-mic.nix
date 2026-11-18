{ pkgs, ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      android-mic = prev.android-mic.overrideAttrs (
        final': prev': {
          buildInputs = prev'.buildInputs ++ [
            final.pkgs.aws-lc
          ];
        }
      );
    })
  ];

  environment.systemPackages = with pkgs; [
    android-mic
  ];

  services.pipewire.extraConfig.pipewire."99-androidmic-loopback" = {
    "context.modules" = [
      {
        "name" = "libpipewire-module-loopback";
        "args" = {
          "node.name" = "android-mic";
          "audio.position" = [
            "FL"
            "FR"
          ];
          "node.passive" = true;
          "capture.props" = {
            "media.class" = "Audio/Sink";
            "node.description" = "AndroidMic Loopback Sink";
          };
          "playback.props" = {
            "media.class" = "Audio/Source";
            "node.description" = "AndroidMic Virtual Microphone";
          };
        };
      }
    ];
    "node.rules" = [
      {
        "matches" = [
          {
            "node.name" = "alsa_playback.android-mic";
          }
        ];
        "actions" = {
          "update-props" = {
            "target.object" = "input.android-mic";
          };
        };
      }
    ];
  };

  networking.firewall.allowedTCPPorts = [ 54345 ];
  networking.firewall.allowedUDPPorts = [ 54345 ];
}
