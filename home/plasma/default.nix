{ pkgs, ... }:

{
  imports = [
    ../../external/plasma-manager/modules
  ];

  programs.plasma = {
    enable = true;
  };
}
