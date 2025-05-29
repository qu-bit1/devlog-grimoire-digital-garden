#!/bin/bash

# Script to commit and push changes in the submodule (content) and then the parent repository.

# Check if a commit message was provided
if [ -z "$1" ]; then
  echo "Error: Please provide a commit message."
  echo "Usage: ./update_garden.sh \"Your commit message\""
  exit 1
fi

COMMIT_MESSAGE="$1"
SUBMODULE_DIR="content"
PARENT_DIR=$(pwd)

# --- Submodule Operations --- 
echo "--- Processing submodule ($SUBMODULE_DIR) --- "

# Navigate into the submodule directory
cd "$SUBMODULE_DIR" || exit 1

# Add all changes
echo "Staging changes in submodule..."
git add .

# Commit changes
echo "Committing changes in submodule with message: 
$COMMIT_MESSAGE"
git commit -m "$COMMIT_MESSAGE"

# Push changes
echo "Pushing submodule changes..."
git push origin

# Check if submodule push was successful
if [ $? -ne 0 ]; then
  echo "Error: Failed to push submodule changes. Aborting."
  cd "$PARENT_DIR"
  exit 1
fi

echo "Submodule push successful."

# --- Parent Repository Operations --- 
echo "--- Processing parent repository --- "

# Navigate back to the parent directory
cd "$PARENT_DIR" || exit 1

# Add the updated submodule and any other changes in the parent repo
echo "Staging changes in parent repository (including submodule update)..."
git add "$SUBMODULE_DIR"
# Optional: Add all other changes in the parent repo too. Uncomment if needed.
# git add .

# Commit changes in the parent repository
# Using a standard message, but you can customize this
PARENT_COMMIT_MESSAGE="Update content submodule to latest commit"
echo "Committing changes in parent repository with message: $PARENT_COMMIT_MESSAGE"
git commit -m "$PARENT_COMMIT_MESSAGE"

# Push changes
echo "Pushing parent repository changes..."
# Assuming your branch is 'v4', change if necessary
BRANCH_NAME="v4" 
git push origin "$BRANCH_NAME"

# Check if parent push was successful
if [ $? -ne 0 ]; then
  echo "Error: Failed to push parent repository changes."
  exit 1
fi

echo "Parent repository push successful."
echo "--- All done! --- "

exit 0

