{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./1password.nix
      ./audio.nix    
      ./hardware-configuration.nix
      ./steam.nix
      ./unfree.nix
      ./users.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "mudkip"; # Define your hostname.

  # Set your time zone.
  time.timeZone = "US/Central";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

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

