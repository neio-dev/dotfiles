# This program will put any config in "auto" dir into corresponding directories
rm -rf ./env/.config/nvim
echo "Deleted local env/.config/nvim folder"
cp -r ~/.config/nvim ./env/.config/nvim
echo "Moved ~/.config/nvim to env/.config/nvim"
git add ./env/.config/nvim*
git commit -m "Updated nvim config"
