{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./1password.nix
      ./audio.nix    
      ./boot.nix
      ./hardware-configuration.nix
      ./locale.nix
      ./steam.nix
      ./unfree.nix
      ./users.nix
    ];

  networking.hostName = "mudkip"; # Define your hostname.

  services.btrfs.autoScrub = {
    enable = true;
    fileSystems = ["/"];
  };
  services.flatpak.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.xserver.enable = true;
  services.xserver.dpi = 163;

  hardware.uinput.enable = true;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  system.copySystemConfiguration = true;

  # This variable is used to indicate API compatibility, and does not need to be changed on
  # version upgrade.
  system.stateVersion = "24.05"; # Did you read the comment?
}

