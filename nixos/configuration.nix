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
    ./desktop-environment.nix
    ./filesystems.nix
    ./flatpak.nix
    ./fonts.nix
    ./hardware-configuration.nix
    ./locale.nix
    ./networking.nix
    ./sleep.nix
    ./steam.nix
    ./unfree.nix
    ./users.nix
  ];

  system.copySystemConfiguration = true;
  # This variable is used to indicate API compatibility, and does not need to be changed on
  # version upgrade.
  system.stateVersion = "24.05"; # Did you read the comment?
}
