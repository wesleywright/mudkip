set -x

TIMESTAMP="$(date --utc --iso-8601=seconds)"
BACKUP_SUBVOLUME=/mnt/games/bg3-backups
LATEST_DIRECTORY="$BACKUP_SUBVOLUME/latest"
SNAPSHOTS_DIRECTORY="$BACKUP_SUBVOLUME/snapshots"
GAME_DIRECTORY="/mnt/games/Steam/steamapps/compatdata/1086940/pfx/drive_c/users/steamuser/AppData/Local/Larian Studios/Baldur's Gate 3/PlayerProfiles/Public/"
SAVEGAMES_DIRECTORY="$GAME_DIRECTORY/Savegames"

rsync -av --delete "$SAVEGAMES_DIRECTORY" "$LATEST_DIRECTORY"
sudo btrfs subvolume snapshot "$BACKUP_SUBVOLUME" "$SNAPSHOTS_DIRECTORY/$TIMESTAMP"
