{ pkgs, ... }:

{
  imports = [
    ../../external/plasma-manager/modules

    ./konsole.nix
  ];

  programs.plasma = {
    enable = true;
  };
}
