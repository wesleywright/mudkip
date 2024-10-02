{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

let
  externalStorageBtrfs = "/dev/disk/by-uuid/3ab5f40a-0c81-4d00-8940-62aea70097c4";
  storage1EncryptedDevice = "/dev/disk/by-label/storage1.luks";
  storage1BtrfsDevice = "/dev/disk/by-label/storage1.btrfs";
in
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "uas"
    "usbhid"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.initrd.luks.devices."storage1".device = storage1EncryptedDevice;

  boot.kernelModules = [
    "amdgpu"
    "kvm-amd"
    "hid_playstation"
  ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = externalStorageBtrfs;
    fsType = "btrfs";
    options = [ "subvol=root" ];
  };

  fileSystems."/home" = {
    device = externalStorageBtrfs;
    fsType = "btrfs";
    options = [ "subvol=home" ];
  };

  fileSystems."/nix" = {
    device = externalStorageBtrfs;
    fsType = "btrfs";
    options = [
      "subvol=nix"
      "noatime"
    ];
  };

  fileSystems."/mnt/games" = {
    device = storage1BtrfsDevice;
    fsType = "btrfs";
    options = [
      "subvol=games"
      # This drive is only used for game content, and shouldn't be considered necessary for booting
      "nofail"
    ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/C1D3-ACEC";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp4s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp3s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
