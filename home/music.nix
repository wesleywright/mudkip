{ pkgs, ... }:

{
  home.packages = [
    pkgs.high-tide
    pkgs.hydrogen
    pkgs.lollypop
  ];
}
