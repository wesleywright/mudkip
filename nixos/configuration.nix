{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./1password.nix
      ./audio.nix    
      ./boot.nix
      ./btrfs.nix
      ./desktop-environment.nix
      ./flatpak.nix
      ./hardware-configuration.nix
      ./locale.nix
      ./networking.nix
      ./steam.nix
      ./unfree.nix
      ./users.nix
    ];

  system.copySystemConfiguration = true;
  # This variable is used to indicate API compatibility, and does not need to be changed on
  # version upgrade.
  system.stateVersion = "24.05"; # Did you read the comment?
}

