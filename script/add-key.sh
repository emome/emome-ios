security create-keychain -p travis ios-build.keychain
security import ./scripts/cert/apple.cer -k ~/Library/Keychains/ios-build.keychain -T /usr/bin/codesign
security import ./scripts/cert/developer.cer -k ~/Library/Keychains/ios-build.keychain -T /usr/bin/codesign
security import ./scripts/cert/developer.p12 -k ~/Library/Keychains/ios-build.keychain -P $IOS_KEY_PASSWORD -T /usr/bin/codesign