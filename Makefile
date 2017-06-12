VERSION=`cut -d '"' -f2 $BUILDDIR/../version.js`

sign:
	gpg -u 1112CFA1 --output browser-extensions/chrome/copay-chrome-extension.zip.sig --detach-sig browser-extensions/chrome/copay-chrome-extension.zip
verify:
	gpg --verify browser-extensions/chrome/copay-chrome-extension.zip.sig browser-extensions/chrome/copay-chrome-extension.zip

sign-osx:
	codesign -s 3rd webkitbuilds/Copay-osx.dmg

verify-osx:
	codesign -dv webkitbuilds/Copay-osx.dmg

sign-desktop:
	gpg -u 1112CFA1 --output webkitbuilds/Copay-linux.zip.sig --detach-sig webkitbuilds/Copay-linux.zip
	gpg -u 1112CFA1 --output webkitbuilds/Copay-win.exe.sig --detach-sig webkitbuilds/Copay-win.exe

verify-desktop:
	gpg --verify webkitbuilds/Copay-linux.zip.sig webkitbuilds/Copay-linux.zip
	gpg --verify webkitbuilds/Copay-win.exe.sig webkitbuilds/Copay-win.exe

chrome:
	browser-extensions/chrome/build.sh

cordova-base:
	grunt dist-mobile

# ios:  cordova-base
# 	make -C cordova ios
# 	open cordova/project/platforms/ios/Copay
#
# android: cordova-base
# 	make -C cordova run-android
#
# release-android: cordova-base
# 	make -C cordova release-android
#
wp8-prod:
	cordova/build.sh WP8 --clear
	cordova/wp/fix-svg.sh
	echo -e "\a"

wp8-debug:
	cordova/build.sh WP8 --dbgjs
	cordova/wp/fix-svg.sh
	echo -e "\a"

ios-prod:
	cordova/build.sh IOS --clear
	cd cordova/project && cordova plugin save && cordova platform rm ios && cordova platform add ios && cordova build ios
	open cordova/project/platforms/ios/LEOPay.xcodeproj

ios-debug:
	cordova/build.sh IOS --dbgjs
	cd cordova/project && cordova plugin save && cordova platform rm ios && cordova platform add ios && cordova build ios
	open cordova/project/platforms/ios/LEOPay.xcodeproj

android-prod:
	cordova/build.sh ANDROID --clear
	rm -f cordova/project/platforms/android/build/outputs/apk/android-release-signed-aligned.apk
	cd cordova/project && cordova build android --release
	jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore LEOPay.keystore -signedjar cordova/project/platforms/android/build/outputs/apk/android-release-signed.apk  cordova/project/platforms/android/build/outputs/apk/android-release-unsigned.apk LEOPay
	../Library/Android/sdk/build-tools/25.0.2/zipalign -v 4 cordova/project/platforms/android/build/outputs/apk/android-release-signed.apk cordova/project/platforms/android/build/outputs/apk/android-release-signed-aligned.apk 


android-debug:
	cordova/build.sh ANDROID --dbgjs
	cd cordova/project && cordova run android

android-debug-fast:
	cordova/build.sh ANDROID --dbgjs
	cd cordova/project && cordova run android	 --device
