{ pkgs, ... }:

{
  home.packages = [
    # Progress Viewer, useful for inspecting miscellaneous byte stream operations
    pkgs.pv
    # Useful for running one-off scripts
    pkgs.python3
    # Like grep, but nicer :-)
    pkgs.ripgrep
  ];
}
