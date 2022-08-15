#!/bin/zsh

BASE_BACKUP_PATH="/Volumes/vlutherJump"


#declare -A DIRS_TO_BACKUP



folders_to_backup=(
    "/Users/vluther/.ssh"
    "/Users/vluther/dotfiles"
    "/Users/vluther/work"
    "/Users/vluther/Downloads"
)


for folder in "${folders_to_backup[@]}" ;do
    echo "Syncing $folder"
    /usr/local/bin/rsync -Cah --info=progress2 --mkpath $folder $BASE_BACKUP_PATH
done;




# echo "Syncing dotSSH folder"
# /usr/local/bin/rsync -Cah --info=progress2 ~/.ssh/ $BASE_BACKUP_PATH/ssh

# echo "Syncing dotfiles folder"
# /usr/local/bin/rsync -Cah --info=progress2 ~/dotfiles/ $BASE_BACKUP_PATH/dotfiles

# echo "Syncing Downloads folder"
# /usr/local/bin/rsync -Cah --info=progress2 ~/Downloads/ $BASE_BACKUP_PATH/Downloads

# echo "Syncing Work folder"
# /usr/local/bin/rsync -Cah --info=progress2 ~/work/ $BASE_BACKUP_PATH/work




