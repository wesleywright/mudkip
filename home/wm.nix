{ pkgs, ... }:

let
  fonts = {
    names = [ "Input Mono" ];
    size = 11.0;
  };

  monitorResolution = {
    width = 3840;
    height = 2160;
  };
  monitorScaleFactor = 1.3;

  lgMonitor = "LG Electronics 27GN950 101NTMXE1251";
  dellMonitor = "Dell Inc. DELL P2715Q 54KKD79CCFVL";
in
{
  wayland.windowManager.sway = {
    enable = true;
    config = {
      bars = [
        {
          fonts = fonts;
          position = "top";
          statusCommand = "${pkgs.i3status}/bin/i3status";
          trayOutput = "*";
        }
      ];

      fonts = fonts;

      gaps = {
        inner = 8;
        smartBorders = "off";
        smartGaps = false;
      };

      # Maps to the "super" key.
      modifier = "Mod4";

      output = {
        "*" = {
          scale = toString monitorScaleFactor;
        };
        ${dellMonitor} = {
          position = "0 0";
        };
        ${lgMonitor} = {
          position = "${toString (builtins.floor (monitorResolution.width / monitorScaleFactor))} 0";
        };
      };

      window = {
        commands = [
          {
            command = "floating enable";
            criteria.class = "1Password";
          }
        ];
        titlebar = false;
      };
    };
    wrapperFeatures.gtk = true;
  };
}
