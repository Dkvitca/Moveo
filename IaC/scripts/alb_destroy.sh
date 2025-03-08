#!/bin/bash
set -e

echo "Updating README.md to indicate infrastructure is down..."
sed -i "s|Application URL: .*|Application URL: Infrastructure is currently down.|" README.md

# Check if README.md actually changed before committing
if git diff --exit-code README.md; then
    echo "No changes detected in README.md. Skipping commit and push."
    exit 0
fi

# Commit and push changes.
git config --global user.email "github-actions@github.com"
git config --global user.name "GitHub Actions"
git remote set-url origin https://x-access-token:${GITHUB_TOKEN}@github.com/${{ github.repository }}.git

echo "Adding README.md to Git..."
git add README.md
git commit -m "Update README: Infrastructure is down"
git push origin main
