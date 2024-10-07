{ pkgs, ... }:

{
  home.packages = [
    # Useful when configuring Konsole/&c.
    pkgs.foot

    # Useful for bootstrapping pins for new projects
    pkgs.npins

    # Progress Viewer, useful for inspecting miscellaneous byte stream operations
    pkgs.pv
    # Useful for running one-off scripts
    pkgs.python3
    # Like grep, but nicer :-)
    pkgs.ripgrep

    pkgs.tree
    pkgs.zip

    (pkgs.writeShellApplication {
      name = "new-project";

      runtimeInputs = [ pkgs.git ];

      text = ''
        case $1 in
          /*) DESTINATION="$(realpath "$1")" ;;
          *) DESTINATION="$(realpath "$PWD/$1")" ;;
        esac

        echo "Creating new git repository at $DESTINATION"
        mkdir -p "$DESTINATION"
        git init "$DESTINATION"

        pushd /home/naptime/development/nix-project-template/ >/dev/null
        echo "Copying Git files to $DESTINATION"
        git checkout-index -f -a --prefix="$DESTINATION/"
        popd >/dev/null

        pushd "$DESTINATION" >/dev/null
        echo "Updating npins"
        npins update
        popd >/dev/null

        echo "Done"
      '';
    })
  ];
}
