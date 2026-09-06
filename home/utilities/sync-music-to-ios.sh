if [[ $# != 1 ]]; then
  echo >&2 "usage: $0 <app ID>"
  exit 1
fi

APP_ID="$1"

MOUNTPOINT=$(mktemp --directory --suffix=.ios-music-sync)
LIBRARY=/mnt/music/by-artist
DESTINATION="$MOUNTPOINT"/"$(basename "$LIBRARY")"/

teardown() {
  echo "sleeping 5 seconds to allow for dangling processes to relinquish FUSE mount"
  sleep 5
  echo "unmounting and removing $MOUNTPOINT"
  umount "$MOUNTPOINT"
  rm -r "$MOUNTPOINT"
}
echo "mounting iOS documents for app $APP_ID to $MOUNTPOINT"
ifuse --documents "$APP_ID" "$MOUNTPOINT"
trap teardown EXIT

echo "syncing from $LIBRARY to $MOUNTPOINT"
rsync \
  -v \
  --size-only \
  --recursive \
  --delete \
  "$LIBRARY"/ "$DESTINATION"/

echo "copying checksums.txt manifest"
cp "$LIBRARY"/checksums.txt "$DESTINATION"/
