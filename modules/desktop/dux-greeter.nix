{ config, ... }:

{
  services.displayManager.dux-greeter = {
    enable = true;
    configHome = config.users.users.nyan.home;
    compositor = {
      name = "niri";
      customConfig = ''
        output "HDMI-A-1" {
          scale 1.67
          layout {
            background-color "#000000"
          }
        }

        cursor {
          xcursor-size 18
          xcursor-theme "breeze_cursors"
        }

        hotkey-overlay {
          skip-at-startup
        }
      '';
    };
  };
  services.displayManager.defaultSession = null;
}
