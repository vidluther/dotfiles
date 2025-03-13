#!/bin/zsh

BASE_BACKUP_PATH="/Volumes/Manual/vluther"

folders_to_backup=(
    "/Users/vluther/.fish"
    "/Users/vluther/.config"
    "/Users/vluther/.aws"
    "/Users/vluther/.ssh"
    "/Users/vluther/.gnupg"
    "/Users/vluther/keys"
    "/Users/vluther/Documents"
    "/Users/vluther/dotfiles"
    "/Users/vluther/work"
    "/Users/vluther/Downloads"
    "/Users/vluther/Pictures"
    "/Users/vluther/Music"
    "/Users/vluther/Movies"
    "/Users/vluther/Desktop"
	"/Users/vluther/Parallels"
)

# Ensure the backup directory exists
mkdir -p "$BASE_BACKUP_PATH"

# Sync folders, ensuring node_modules are skipped
for folder in "${folders_to_backup[@]}" ; do
    echo "Syncing $folder..."
    /opt/homebrew/bin/rsync -CahX --info=progress2 \
        --exclude='*/node_modules' --delete-after --delete-excluded \
        "$folder" "$BASE_BACKUP_PATH"
done

# Remove empty directories in backup to clean up
find "$BASE_BACKUP_PATH" -type d -empty -delete

echo "✅ Backup completed!"
