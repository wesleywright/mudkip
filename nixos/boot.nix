{ pkgs, ... }:

{
  # The default Kernel (6.12) seemed to be causing some odd hanging issues as of
  # 2025-08-30; pinning to 6.6 as a possible workaround.
  boot.kernelPackages = pkgs.linuxPackages_6_6;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
}
