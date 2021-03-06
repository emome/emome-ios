if [[ "$TRAVIS_PULL_REQUEST" != "false" ]]; then
  echo "This is a pull request. No deployment will be done."
  exit 0
fi

if [[ "$TRAVIS_BRANCH" != "master" ]]; then
  echo "Testing on a branch other than master. No deployment will be done."
  exit 0
fi

rm -rf ARCHIVE_PATH
echo "**************"
echo "*  Cleaning  *"
echo "**************"
xctool clean -workspace ${WORKSPACE} -scheme ${SCHEME}

echo "*************************"
echo "*  Archiving Workspace  *"
echo "*************************"
xctool -configuration Debug -workspace ${WORKSPACE} -scheme ${SCHEME} archive -archivePath "${ARCHIVE_PATH}/${APP_NAME}" ONLY_ACTIVE_ARCH=NO CODE_SIGN_REQUIRED=YES CODE_SIGN_IDENTITY="iPhone Developer: hc.acsalu@gmail.com (T87LB7SF6L)"

echo "*******************"
echo "*  Packaging IPA  *"
echo "*******************"
xcrun -sdk iphoneos PackageApplication -v  "${PROJECT_BUILD_DIR}"/*.app -o "${ARCHIVE_PATH}/${APP_NAME}.ipa"

echo "*******************************"
echo "*  Distributing to Fabric.io  *"
echo "*******************************"
./Pods/Crashlytics/submit $FABRIC_API_KEY $FABRIC_BUILD_SECRET -groupAliases "early-birds" -ipaPath "${ARCHIVE_PATH}/${APP_NAME}.ipa"
