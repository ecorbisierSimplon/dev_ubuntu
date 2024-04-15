#!/bin/bash
source $FUNCTIONS_FILE
source ~/.bashrc 
source ~/.bash_aliases


echo ""
echo "======================================================"
echo "                 NUM : 'script settings save'"
echo "======================================================"
echo ""

# Execut in terminal :
# chmod +x ./script-settings-save.sh && ./script-settings-save.sh

file_rel_settings=~/Documents/dev_ubuntu/files/layout/settings.sh
source "$file_rel_settings"

for app_folder in "${tab[@]}"; do
    read -r app_name tab_app_settings <<<"$app_folder"
    
    for app_setting_line in "${tab_app_settings[@]}"; do
    	read -r app_setting_name app_setting <<<"$app_setting_line"
    	echo "$app_name -> '$app_setting_name'='$app_setting'"
    done
done
