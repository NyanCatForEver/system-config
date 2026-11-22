{ config, ... }:

{
  services.displayManager.dux-greeter = {
    enable = true;
    configHome = config.users.users.nyan.home;
    compositor = {
      name = "niri";
      customConfig = ''
        layout {
          background-color "#000000"
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
