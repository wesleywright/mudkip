{ pkgs, ... }:

{
  home.packages = [
    # Useful when configuring Konsole/&c.
    pkgs.foot

    # Useful for bootstrapping pins for new projects
    pkgs.npin

    # Progress Viewer, useful for inspecting miscellaneous byte stream operations
    pkgs.pv
    # Useful for running one-off scripts
    pkgs.python3
    # Like grep, but nicer :-)
    pkgs.ripgrep

    pkgs.tree
    pkgs.zip
  ];
}
