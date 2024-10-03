{ ... }:

{
  programs = {
    sway.enable = true;
  };

  services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm.enable = true;
  services.displayManager.defaultSession = "sway";
  services.xserver.enable = true;
  services.xserver.dpi = 162;
}
