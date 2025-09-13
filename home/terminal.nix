{ pkgs, ... }:

{
  programs.ghostty = {
    enable = true;
    enableFishIntegration = true;

    settings = {
      font-family = "Input Mono";
      font-size = 14;

      theme = "Builtin Solarized Dark";

      window-decoration = "client";
      window-theme = "ghostty";
    };
  };
}
