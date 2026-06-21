{ config, pkgs, ... }:

{
  programs.firefox = {
    # New default as of 26.05; set explicitly to silence warnings
    configPath = "${config.xdg.configHome}/mozilla/firefox";

    enable = true;
    nativeMessagingHosts = [ pkgs.kdePackages.plasma-browser-integration ];
  };
}
