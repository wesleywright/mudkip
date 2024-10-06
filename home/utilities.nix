{ pkgs, ... }:

{
  home.packages = [
    # Useful when configuring Konsole/&c.
    pkgs.foot

    # Progress Viewer, useful for inspecting miscellaneous byte stream operations
    pkgs.pv
    # Useful for running one-off scripts
    pkgs.python3
    # Like grep, but nicer :-)
    pkgs.ripgrep

    pkgs.tree
  ];
}
