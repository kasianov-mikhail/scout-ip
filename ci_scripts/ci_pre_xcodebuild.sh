#!/bin/sh

echo "Stage: PRE-Xcode Build is activated .... "

# Move to the place where the scripts are located.
# This is important because the position of the subsequently mentioned files depend of this origin.
cd $CI_PRIMARY_REPOSITORY_PATH/ci_scripts || exit 1

# Write a JSON File containing all the environment variables and secrets.
printf "{\"IPINFO_KEY\":\"%s\"}" "$IPINFO_KEY" >> ../ScoutIP/Resources/Secrets.json

echo "Wrote Secrets.json file."

echo "Stage: PRE-Xcode Build is DONE .... "

exit 0