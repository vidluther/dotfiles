#!/bin/zsh

BASE_BACKUP_PATH="/Volumes/vlutherJump"


#declare -A DIRS_TO_BACKUP



folders_to_backup=(
    "/Users/vluther/.aws"
    "/Users/vluther/.ssh"
    "/Users/vluther/.gnupg"
    "/Users/vluther/keys"
    "/Users/vluther/dotfiles"
    "/Users/vluther/work"
    "/Users/vluther/Downloads"
)

# make sure we don't sync the node_modules folder in all the
# react/node apps. 

for folder in "${folders_to_backup[@]}" ;do
    echo "Syncing $folder"
    /usr/local/bin/rsync -Cah -m --info=progress2 --exclude 'node_modules' --delete-after --delete-excluded --mkpath $folder $BASE_BACKUP_PATH
done;






