{ pkgs, ... }:

let
  backup-bg3 = pkgs.writeShellApplication {
    name = "backup-bg3";
    runtimeInputs = [
      pkgs.coreutils
      pkgs.gnutar
    ];
    text = ''
      set -x

      TIMESTAMP="$(date --utc --iso-8601=seconds)"
      DESTINATION="$HOME/Documents/BG3/Backups/backup.$TIMESTAMP.tar.gz"
      GAME_DIRECTORY="/mnt/games/Steam/steamapps/compatdata/1086940/pfx/drive_c/users/steamuser/AppData/Local/Larian Studios/Baldur's Gate 3/PlayerProfiles/Public/"
      SAVEGAMES="Savegames"

      mkdir -p "$(dirname "$DESTINATION")"
      tar czvf "$DESTINATION" -C "$GAME_DIRECTORY" "$SAVEGAMES"
    '';
  };
in
{
  home.packages = [
    backup-bg3

    # Like cat, but prettier
    pkgs.bat

    # Useful when configuring Konsole/&c.
    pkgs.foot

    # Querying language for JSON; useful for miscellaneous JSON tasks
    pkgs.jq

    # Progress Viewer, useful for inspecting miscellaneous byte stream operations
    pkgs.pv
    # Useful for running one-off scripts.
    # Pinned to 3.14 now since the default is 3.12; we can move to default
    # on future versions, or continue to pin newer versions.
    pkgs.python314
    # Like grep, but nicer :-)
    pkgs.ripgrep

    pkgs.tree
    pkgs.zip
    pkgs.htop

    # Various networking utilities
    pkgs.dig
    pkgs.whois
  ];
}
