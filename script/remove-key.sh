if [[ "$TRAVIS_PULL_REQUEST" != "false" ]]; then
  echo "This is a pull request. No need to remove keys"
  exit 0
fi

if [[ "$TRAVIS_BRANCH" != "master" ]]; then
  echo "This is a pull request. No need to remove keys"
  exit 0
fi

security delete-keychain ios-build.keychain
rm -f ~/Library/MobileDevice/Provisioning\ Profiles/*