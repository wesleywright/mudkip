{ lib, ... }:

{
  # This seems to help with fully recognizing DualSense controllers.
  hardware.uinput.enable = true;

  programs.steam.enable = true;
}
