# run this script from the dir where you want to clone the repos

# List of mfes
mfes=(
    "frontend-app-authn"
    "frontend-app-account"
    "frontend-app-communications"
    "frontend-app-course-authoring"
    "frontend-app-discussions"
    "frontend-app-gradebook"
    "frontend-app-learner-dashboard"
    "frontend-app-learning"
    "frontend-app-ora-grading"
    "frontend-app-profile"
)

# Loop through and clone each repo
for mfe in "${mfes[@]}"; do
  if [ ! -d "$mfe" ]; then
    git clone "https://github.com/openedx/$mfe.git"
done