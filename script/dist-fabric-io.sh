if [[ "$TRAVIS_PULL_REQUEST" != "false" ]]; then
  echo "This is a pull request. No deployment will be done."
  exit 0
fi

if [[ "$TRAVIS_BRANCH" != "master" ]]; then
  echo "Testing on a branch other than master. No deployment will be done."
  exit 0
fi

rm -rf ARCHIVE_PATH
xctool clean -workspace ${WORKSPACE} -scheme ${SCHEME}
xctool -workspace ${WORKSPACE} -scheme ${SCHEME} archive -archivePath "${ARCHIVE_PATH}/${APP_NAME}" ONLY_ACTIVE_ARCH=NO CODE_SIGNING_REQUIRED=YES CODE_SIGN_IDENTITY="iPhone Developer" 
xcrun -sdk iphoneos PackageApplication -v  "${PROJECT_BUILD_DIR}"/*.app -o "${ARCHIVE_PATH}/${APP_NAME}.ipa"
../Pods/Crashlytics/Crashlytics.framework/submit $FABRIC_API_KEY $FABRIC_BUILD_SECRET -groupAliases ﻿"early-birds" -ipaPath "${ARCHIVE_PATH}/${APP_NAME}.ipa"