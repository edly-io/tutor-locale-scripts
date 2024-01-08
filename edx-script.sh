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

files=('django.po' 'djangojs.po')
# Create django.po and djangojs.po files if they do not exist
if [ ! -d "$LOCALE_FOLDER/edx-platform/$EDX_LANG/LC_MESSAGES" ]; then
  mkdir -p "$LOCALE_FOLDER/edx-platform/$EDX_LANG/LC_MESSAGES"
  echo "Created missing folder: $LOCALE_FOLDER/edx-platform/$EDX_LANG/LC_MESSAGES"
  
  for file in "${files[@]}"; do
    tutor dev run lms cat conf/locale/$EDX_LANG/LC_MESSAGES/$file > $LOCALE_FOLDER/edx-platform/$EDX_LANG/LC_MESSAGES/$file
    sed -i '' '1d' $LOCALE_FOLDER/edx-platform/$EDX_LANG/LC_MESSAGES/$file
    echo "Created missing $file file"
  done
fi

# Extract missing translations from django.po and djangojs.po files
if [ ! -d "$LOCALE_FOLDER/missing/edx/$EDX_LANG" ]; then
  mkdir -p "$LOCALE_FOLDER/missing/edx/$EDX_LANG"
  echo "Created missing folder: $LOCALE_FOLDER/missing/edx/$EDX_LANG"
fi

for file in "${files[@]}"; do
  #  get untranslated strings
  msgattrib --untranslated $LOCALE_FOLDER/edx-platform/$EDX_LANG/LC_MESSAGES/django.po > $LOCALE_FOLDER/missing/edx/$EDX_LANG/django.po

  msgattrib --untranslated $LOCALE_FOLDER/edx-platform/$EDX_LANG/LC_MESSAGES/djangojs.po > $LOCALE_FOLDER/missing/edx/$EDX_LANG/djangojs.po
done
