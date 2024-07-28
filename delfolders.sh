#!/bin/bash

if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
  echo "Usage: $0 <folder> [path]"
  exit 1
fi

FOLDER_NAME=$1
INITIAL_PATH=${2:-.}

if [ ! -d "$INITIAL_PATH" ]; then
  echo "Invalid path."
  exit 1
fi

folders_deleted=0
files_deleted=0

delete_folders()
{
  local path=$1
  local folder_name=$2

  find "$path" -type d -name "$folder_name" -prune | while read -r folder; do
    num_files=$(find "$folder" -type f | wc -l)
    files_deleted=$((files_deleted + num_files))
    folders_deleted=$((folders_deleted + 1))

    rm -rf "$folder"
  done
}

delete_folders "$INITIAL_PATH" "$FOLDER_NAME"

echo "Deleted $folders_deleted folders and $files_deleted files."
