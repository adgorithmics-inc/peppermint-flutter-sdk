#!/usr/bin/env bash
echo "Reformatting Flutter code..."

# Reformat Flutter code using the flutter format command
dart format . &

# Wait for the flutter format command to complete
wait $!

echo "Checking for changes to commit..."

# Check if there are any changes to commit
if git diff-index --quiet HEAD --; then
  echo "No changes to commit. Skipping commit."
else
  echo "Changes detected. Adding modified files to staging area..."
  git add .
fi