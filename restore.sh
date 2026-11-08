#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

echo "Starting the restore script..."

# Find all .back files and restore them safely
# Using find with -print0 and a while read loop with a null delimiter
# is the safest way to handle filenames with spaces or special characters.
find . -type f -name "*.back" -print0 | while IFS= read -r -d '' backup_file; do
    original_file=$(echo "$backup_file" | sed 's/\.back$//')
    if [ -f "$backup_file" ]; then # Check if the backup file actually exists
        echo "Restoring '$original_file' from '$backup_file'..."
        mv -f "$backup_file" "$original_file"
    else
        echo "Warning: Backup file '$backup_file' not found, skipping."
    fi
done

# Remove log files and other artifacts created by modification scripts
ARTIFACTS=("branding_changed_files.txt")
for artifact in "${ARTIFACTS[@]}"; do
    if [ -f "$artifact" ]; then
        echo "Removing artifact '$artifact'..."
        rm -f "$artifact"
    fi
done

echo "Restore script finished successfully."
