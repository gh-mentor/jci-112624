# This bash script uses git to synchronize changes between a local and remote GitHub repository on branch 'main'.

# Steps: pull changes from remote repository, stage all changes, commit changes with message 'Updated', push changes to remote repository on branch 'main'.

# Pull the latest changes from the remote repository on branch 'main'.
git pull origin main

# Stage all changes.
git add .

# Commit changes with message 'Updated'.
git commit -m "Updated"

# Push changes to the remote repository on branch 'main'.
git push origin main

# Echo a message to the terminal indicating that the synchronization process is complete.
echo "Synchronization complete"
