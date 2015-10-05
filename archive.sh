#!/bin/bash
set -x

PROJECT=EMOME
SCHEME=EmomeTests
ARCHIVE_PATH=`pwd`/archive
IPA_NAME=${PROJECT}

PROJECT_BUILD_DIR=${ARCHIVE_PATH}/${IPA_NAME}.xcarchive/Products/Applications

xctool clean -workspace ${PROJECT}.xcworkspace -scheme ${SCHEME}
xctool -workspace ${PROJECT}.xcworkspace -scheme ${SCHEME} archive -archivePath "${ARCHIVE_PATH}/${IPA_NAME}" ONLY_ACTIVE_ARCH=NO CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO
xcrun -sdk iphoneos PackageApplication -v  "${PROJECT_BUILD_DIR}"/*.app -o "${ARCHIVE_PATH}/${IPA_NAME}.ipa"