{ pkgs, ... }:

{
  imports = [
    ./konsole.nix
  ];

  programs.plasma = {
    enable = true;
  };
}
