{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./1password.nix
    ./audio.nix
    ./boot.nix
    ./command-not-found.nix
    ./desktop-environment.nix
    ./fans.nix
    ./filesystems.nix
    ./flatpak.nix
    ./fonts.nix
    ./hardware-configuration.nix
    ./keyboard.nix
    ./locale.nix
    ./networking.nix
    ./nix.nix
    ./steam.nix
    ./udev.nix
    ./users.nix
    ./virtualization.nix
  ];

  # This variable is used to indicate API compatibility, and does not need to be changed on
  # version upgrade.
  system.stateVersion = "24.05"; # Did you read the comment?
}
