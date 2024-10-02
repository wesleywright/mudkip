{ ... }:

let
  # Constants for storage devices.
  externalStorageBoot = "/dev/disk/by-uuid/C1D3-ACEC";
  externalStorageBtrfs = "/dev/disk/by-uuid/3ab5f40a-0c81-4d00-8940-62aea70097c4";
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
      device = externalStorageBtrfs;
      subvolume = subvolume;
      extraOptions = extraOptions;
    };
  storage1Subvolume =
    subvolume: extraOptions:
    btrfsSubvolume {
      device = storage1BtrfsDevice;
      subvolume = subvolume;
      extraOptions = extraOptions;
    };
in
{
  # Each encrypted device needs to be listed here so that it can be decrypted
  # on bootup.
  boot.initrd.luks.devices."storage1".device = storage1EncryptedDevice;

  fileSystems = {
    "/boot" = {
      device = externalStorageBoot;
      fsType = "vfat";
      options = [
        "fmask=0022"
        "dmask=0022"
      ];
    };

    "/" = primarySubvolume "root" [ ];
    "/home" = primarySubvolume "home" [ ];
    "/nix" = primarySubvolume "nix" [ "noatime" ];

    "/mnt/games" = storage1Subvolume "games" [
      # Since this drive only has game content, we can continue booting if it
      # fails to mount
      "nofail"
    ];
  };

  swapDevices = [ ];
}