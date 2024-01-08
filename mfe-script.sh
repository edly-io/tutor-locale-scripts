#!/bin/bash

# Check if the environment variables are set
if [ -z "$EDX_LANG" ]; then
  echo "EDX_LANG environment variable is not set. Please set the language code in the EDX_LANG environment variable."
  exit 1
fi
if [ -z "$LOCALE_FOLDER" ]; then
  echo "LOCALE_FOLDER environment variable is not set. Please set the language code in the LOCALE_FOLDER environment variable."
  exit 1
fi

# List of folders you want to enter and run commands in
apps=("authn" "account" "communications" "course-authoring" "discussions" "gradebook" "learner-dashboard" "learning" "ora-grading" "profile")

# Loop through each folder in the list
for app in "${apps[@]}"; do
  # Check if the folder exists before changing to it
  folder="frontend-app-$app"
  export APP=$app
  if [ -d "$folder" ]; then
    #  create missing folders
    if [ ! -d "$LOCALE_FOLDER/mfe/$app" ]; then
      mkdir -p "$LOCALE_FOLDER/mfe/$app"
      echo "Created missing folder: $LOCALE_FOLDER/mfe/$app"
    fi
    if [ ! -d "$LOCALE_FOLDER/missing/mfe/$EDX_LANG" ]; then
      mkdir -p "$LOCALE_FOLDER/missing/mfe/$EDX_LANG"
      echo "Created missing folder: $LOCALE_FOLDER/missing/mfe/$EDX_LANG"
    fi

    cp "$LOCALE_FOLDER/mfe/$app/en.json" "$folder/old-en.json"
     
    echo "Entering $folder..."
    cd "$folder" || exit 1  # Change to the folder; exit if unsuccessful

    # extract translations
    make extract_translations
    
    # Run script to merge translations
    node ../edx-scripts/localization/merge-mfe-trans.js
    
    echo "Commands executed in $folder."
    cd ..  # Return to the original directory
    
    cp "./$folder/merged_file.json" "$LOCALE_FOLDER/mfe/$app/$EDX_LANG.json"
    cp "./$folder/untrans_file.json" "$LOCALE_FOLDER/missing/mfe/$EDX_LANG/$app.json"
    cp "./$folder/src/i18n/transifex_input.json" "$LOCALE_FOLDER/mfe/$app/en.json"
  else
    echo "Folder $folder does not exist."
  fi
done
