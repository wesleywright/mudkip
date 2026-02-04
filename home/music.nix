{ pkgs, ... }:

{
  home.packages = [
    # Native client for Tidal
    pkgs.high-tide
    # Open source drum machine
    pkgs.hydrogen
    # Nice player for locally-stored files
    pkgs.lollypop
    # Open source Shazam client
    pkgs.songrec
  ];
}
