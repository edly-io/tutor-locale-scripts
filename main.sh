# run this script from the tutor resources folder

# set global variables
sh tutor-localization-scripts/variables.sh
# handle edx translations
sh tutor-localization-scripts/edx-script.sh
#  handle mfe translations
sh tutor-localization-scripts/clone-mfe.sh
sh tutor-localization-scripts/mfe-script.sh