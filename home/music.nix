{ pkgs, ... }:

{
  home.packages = [
    pkgs.hydrogen
    pkgs.lollypop
  ];
}
