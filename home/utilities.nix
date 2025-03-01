{ pkgs, ... }:

{
  home.packages = [
    # Like cat, but prettier
    pkgs.bat

    # Useful when configuring Konsole/&c.
    pkgs.foot

    # Querying language for JSON; useful for miscellaneous JSON tasks
    pkgs.jq

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
