{ ... }:

let
  # Constants for storage devices.
  mudkipBootDevice = "/dev/disk/by-label/MUDKIP_BOOT";
  mudkipEncryptedDevice = "/dev/disk/by-label/mudkip.luks";
  mudkipBtrfsDevice = "/dev/disk/by-label/mudkip.btrfs";
  storage1EncryptedDevice = "/dev/disk/by-label/storage1.luks";
  storage1BtrfsDevice = "/dev/disk/by-label/storage1.btrfs";

  # Convenience functions for specifying btrfs subvolume mounts.
  btrfsSubvolume =
    {
      device,
      subvolume,
      extraOptions ? [ ],
    }:
    {
      device = device;
      fsType = "btrfs";
      options = [ "subvol=${subvolume}" ] ++ extraOptions;
    };
  primarySubvolume =
    subvolume: extraOptions:
    btrfsSubvolume {
      device = mudkipBtrfsDevice;
      subvolume = subvolume;
      extraOptions = extraOptions;
    };
  storage1Subvolume =
    subvolume: extraOptions:
    btrfsSubvolume {
      device = storage1BtrfsDevice;
      subvolume = subvolume;
      # Since this storage is only used for media and not for critical system
      # components, we don't want to fail the boot if it fails to mount.
      extraOptions = extraOptions ++ [ "nofail" ];
    };

  mkSnapperConfig = mountPoint: {
    SUBVOLUME = mountPoint;
    TIMELINE_CREATE = true;
    TIMELINE_CLEANUP = true;
    TIMELINE_LIMIT_HOURLY = 24 * 7;
    TIMELINE_LIMIT_DAILY = 14;
    TIMELINE_LIMIT_WEEKLY = 8;
    TIMELINE_LIMIT_MONTHLY = 12;
  };
in
{
  # Each encrypted device needs to be listed here so that it can be decrypted
  # on bootup.
  boot.initrd.luks.devices."mudkip".device = mudkipEncryptedDevice;
  boot.initrd.luks.devices."storage1".device = storage1EncryptedDevice;

  fileSystems = {
    "/boot" = {
      device = mudkipBootDevice;
      fsType = "vfat";
      options = [
        "fmask=0022"
        "dmask=0022"
      ];
    };

    "/" = primarySubvolume "root" [ ];
    "/home" = primarySubvolume "home" [ ];
    "/nix" = primarySubvolume "nix" [ "noatime" ];

    "/mnt/games" = storage1Subvolume "games" [ ];
    "/mnt/audiobooks" = storage1Subvolume "audiobooks" [ ];
    "/mnt/music" = storage1Subvolume "music" [ ];
  };

  services.btrfs.autoScrub = {
    enable = true;
    fileSystems = [
      "/"
      "/mnt/games"
    ];
  };
  services.snapper = {
    configs = {
      home = mkSnapperConfig "/home";

      audiobooks = mkSnapperConfig "/mnt/audiobooks";
      games = mkSnapperConfig "/mnt/games";
      music = mkSnapperConfig "/mnt/music";
    };
    persistentTimer = true;
  };

  swapDevices = [ ];
}
