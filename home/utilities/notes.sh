DIRECTORY="$HOME"/notes/"$(date +%Y)"/"$(date +%m)"
FULL_PATH="$DIRECTORY"/"$(date +%d)".md
mkdir -p "$DIRECTORY"
touch "$FULL_PATH"
exec nvim "$FULL_PATH"

