{ pkgs, ... }:

{
  imports = [
    ./konsole.nix
    ./startup.nix
  ];

  programs.plasma = {
    enable = true;
  };
}
