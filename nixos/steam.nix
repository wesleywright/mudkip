{ lib, ... }:

{
  # This seems to help with fully recognizing DualSense controllers.
  hardware.uinput.enable = true;

  programs = {
    # Gamemode allows games to enable OS performance optimizations dynamically, which can have a major boost for some games
    gamemode.enable = true;

    steam.enable = true;
  };

  # Setting CPU governor settings only works when the user is in this group
  users.users.naptime.extraGroups = [ "gamemode" ];
}
