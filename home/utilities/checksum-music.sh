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
