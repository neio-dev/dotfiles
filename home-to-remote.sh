#!/bin/bash
# This program will put any config in "auto" dir into corresponding directories

# nvim
rm -rf ./env/.config/nvim
echo "Deleted local env/.config/nvim folder"
cp -r ~/.config/nvim ./env/.config/
echo "Copied ~/.config/nvim to env/.config/nvim"
git add ./env/.config/nvim*
git commit -m "${*:-Updated nvim config}"

# zellij
rm -rf ./env/.config/zellij
echo "Deleted local env/.config/zellij folder"
cp -r ~/.config/zellij ./env/.config/
echo "Copied ~/.config/zellij to env/.config/zellij"
git add ./env/.config/zellij*
git commit -m "${*:-Updated zellij config}"

