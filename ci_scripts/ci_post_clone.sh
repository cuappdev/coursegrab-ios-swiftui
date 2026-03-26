#!/bin/sh

# ci_post_clone.sh
# CourseGrab

echo "Installing Swiftlint via Homebrew"
brew install swiftlint

echo "Downloading Secrets"
brew install wget
cd $CI_PRIMARY_REPOSITORY_PATH/ci_scripts
mkdir ../CourseGrabSecrets
wget -O ../CourseGrabSecrets/Keys.plist "$KEYS"
wget -O ../CourseGrabSecrets/GoogleService-Info.plist "$GOOGLE_PLIST"
