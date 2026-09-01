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
      BACKUP_SUBVOLUME=/mnt/games/bg3-backups
      LATEST_DIRECTORY="$BACKUP_SUBVOLUME/latest"
      SNAPSHOTS_DIRECTORY="$BACKUP_SUBVOLUME/snapshots"
      GAME_DIRECTORY="/mnt/games/Steam/steamapps/compatdata/1086940/pfx/drive_c/users/steamuser/AppData/Local/Larian Studios/Baldur's Gate 3/PlayerProfiles/Public/"
      SAVEGAMES_DIRECTORY="$GAME_DIRECTORY/Savegames"

      rsync -av --delete "$SAVEGAMES_DIRECTORY" "$LATEST_DIRECTORY"
      sudo btrfs subvolume snapshot "$BACKUP_SUBVOLUME" "$SNAPSHOTS_DIRECTORY/$TIMESTAMP"
    '';
  };

  notes = pkgs.writeShellApplication {
    name = "notes";
    runtimeInputs = [
      pkgs.neovim
    ];
    text = ''
      DIRECTORY="$HOME"/notes/"$(date +%Y)"/"$(date +%m)"
      FULL_PATH="$DIRECTORY"/"$(date +%d)".md
      mkdir -p "$DIRECTORY"
      touch "$FULL_PATH"
      exec nvim "$FULL_PATH"
    '';
  };

  checksum-music = pkgs.writeShellApplication {
    name = "checksum-music";
    runtimeInputs = [
      pkgs.coreutils
      pkgs.findutils
      pkgs.python3Packages.tqdm
    ];
    text = ''
      LIBRARY=/mnt/music/by-artist

      pushd "$LIBRARY"
      echo "Generating new checksum snapshot for $LIBRARY..."

      find . -type f -not -name 'checksums.txt*' | tqdm | while read -r FILENAME; do
        sha256sum "$FILENAME"
      done >checksums.txt.new

      read -r -p "New checksums ready. Press enter to view."
      diff -u checksums.txt checksums.txt.new | less || true
      read -r -p "Confirm new checksum snapshot? (y/N)" ANSWER

      if [[ $ANSWER =~ ^[Yy]$ ]]; then
        mv checksums.txt.new checksums.txt
      else
        echo "Aborting."
      fi
    '';
  };
in
{
  home.packages = [
    # Custom scriptlets
    backup-bg3
    notes
    checksum-music

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

    # Miscellaneous shell conveniences
    pkgs.tree
    pkgs.zip
    pkgs.unzip
    pkgs.htop

    # Various networking utilities
    pkgs.dig
    pkgs.whois

    # Webcam viewer for convenience
    pkgs.kdePackages.kamoso
  ];
}
