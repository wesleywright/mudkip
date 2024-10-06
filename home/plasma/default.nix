{ pkgs, ... }:

{
  imports = [
    <plasma-manager/modules>

    ./konsole.nix
  ];

  programs.plasma = {
    enable = true;
  };
}
