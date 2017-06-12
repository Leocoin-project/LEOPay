#! /bin/bash
#
# Usage:
# sh ./build.sh --android --reload
#
#
# Check function OK
checkOK() {
  if [ $? != 0 ]; then
    echo "${OpenColor}${Red}* ERROR. Exiting...${CloseColor}"
    exit 1
  fi
}

# Configs
BUILDDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT="$BUILDDIR/project"

CURRENT_OS=$1

if [ -z "CURRENT_OS" ]
then
 echo "Build.sh WP8|ANDROID|IOS"
fi

CLEAR=false
DBGJS=false

if [[ $2 == "--clear" || $3 == "--clear" ]]
then
  CLEAR=true
fi

if [[ $2 == "--dbgjs" || $3 == "--dbgjs" ]]
then
  DBGJS=true
fi


echo "${OpenColor}${Green}* Checking dependencies...${CloseColor}"
command -v cordova >/dev/null 2>&1 || { echo >&2 "Cordova is not present, please install it: sudo npm -g cordova."; exit 1; }
#command -v xcodebuild >/dev/null 2>&1 || { echo >&2 "XCode is not present, install it or use [--android]."; exit 1; }

# Create project dir
if $CLEAR
then
  if [ -d $PROJECT ]; then
    rm -rf $PROJECT
  fi
fi

echo "Build directory is $BUILDDIR"
echo "Project directory is $PROJECT"


if [ ! -d $PROJECT ]; then
  cd $BUILDDIR
  echo "${OpenColor}${Green}* Creating project... ${CloseColor}"
  cordova create project org.leocoin.leopay leopay
  checkOK
  cd $PROJECT
  if [ $CURRENT_OS == "ANDROID" ]; then
    echo "${OpenColor}${Green}* Adding Android platform... ${CloseColor}"
    cordova platforms add android@5.1.1
    checkOK
  fi

  if [ $CURRENT_OS == "IOS" ]; then
    echo "${OpenColor}${Green}* Adding IOS platform... ${CloseColor}"
    cordova platforms add ios
    checkOK
  fi

  if [ $CURRENT_OS == "WP8" ]; then
    echo "${OpenColor}${Green}* Adding WP8 platform... ${CloseColor}"
    cordova platforms add wp8
    checkOK
  fi

  echo "${OpenColor}${Green}* Installing plugins... ${CloseColor}"

  if [ $CURRENT_OS == "IOS" ]
  then
    cordova plugin add https://github.com/tjwoon/csZBar.git#fc5dcc300b08d59aef51b15172720efefe873a96
    checkOK
  else
    cordova plugin add https://github.com/jrontend/phonegap-plugin-barcodescanner.git#3a4b4ea69c8bff86f9749f7af332fc5b58c88601
    checkOK
  fi

  if [ $CURRENT_OS == "IOS" ]; then
    cordova plugin add https://github.com/phonegap/phonegap-plugin-push.git#1.5.3
    checkOK
  fi

  if [ $CURRENT_OS == "ANDROID" ]; then
    cordova plugin add https://github.com/phonegap/phonegap-plugin-push.git#1.2.3
    checkOK
  fi

  cordova plugin add https://github.com/apache/cordova-plugin-globalization.git#40e89b1ca164d4b3cf9eb3aee178ef8fda3102fc
  checkOK

  cordova plugin add https://github.com/dpa99c/cordova-diagnostic-plugin.git#0c70da22de3d5a3d0e72267f89a7c57cb7036458
  checkOK

  cordova plugin add https://github.com/apache/cordova-plugin-splashscreen.git#1185561549eb7e3780a9d43a1795662692843444
  checkOK

  cordova plugin add https://github.com/apache/cordova-plugin-statusbar.git#916cccc2c00a1b7c77e2e738c83e74a22bdd55e7
  checkOK

  cordova plugin add https://github.com/cmgustavo/Custom-URL-scheme.git --variable URL_SCHEME=bitcoin --variable SECOND_URL_SCHEME=copay
  checkOK

  cordova plugin add https://github.com/apache/cordova-plugin-inappbrowser.git#0f5de8524f8f83c52e10d32da1d45f102086b5dd
  checkOK

  cordova plugin add https://github.com/413326885/cordova-plugin-x-toast.git#f3767b43277d1e74201b9d4a52154bed6f0cc3be
  cordova prepare
  checkOK

  cordova plugin add https://github.com/VersoSolutions/CordovaClipboard.git#03fe48b62411cbff22229ca13cc3ac8b282f7945
  checkOK

  cordova plugin add https://github.com/EddyVerbruggen/SocialSharing-PhoneGap-Plugin.git#5eb6019ea2addec6f7f754913425a8c22f7f3284
  cordova prepare
  checkOK

  cordova plugin add https://github.com/MadrinX/cordova-progress-dialog.git#702cd341ab791ad8e12b627ac575812f24e9f96c
  checkOK

  cordova plugin add https://github.com/apache/cordova-plugin-dialogs.git#3b5cc87e7c8b15cbb91c77c216c766917aa007c7
  checkOK

  cordova plugin add https://github.com/apache/cordova-plugin-network-information.git#d8c1b0b503e349b61274dab39fae14241d40f14e
  checkOK

  cordova plugin add https://github.com/apache/cordova-plugin-console.git#2faa230149b4c2fe57e14c067ca2345fd60d40c0
  checkOK

  cordova plugin add https://github.com/Paldom/UniqueDeviceID.git#43db5bb48d630fc643d0084b1b124fd9f460fec3
  checkOK

  cordova plugin add https://github.com/apache/cordova-plugin-file.git#4325302f5c891471a0409c3f2239f3c6fb87b549
  checkOK

  cordova plugin add https://github.com/EddyVerbruggen/cordova-plugin-touch-id.git#20d187343a6ee0612e229b26f687ea36e8d9ff09
  cordova prepare
  checkOK

  cordova plugin add https://github.com/leecrossley/cordova-plugin-transport-security.git#898f2a580f78c95b41870efa0412f3457a31f99d
  checkOK

  cordova plugin add https://github.com/chancezeus/cordova-ios-requires-fullscreen.git#edcde97513254450221af8fed8a998c41855bf4f
  checkOK

  cordova plugin add https://github.com/akofman/cordova-plugin-disable-bitcode.git#1cf10251e5dafbea0602f17af2b02d84f3a74c1c
  checkOK

  ## Fix plugin android-fingerprint
  rm -rf $PROJECT/platforms/android/res/values-es
  cordova plugin add cordova-plugin-android-fingerprint-auth@0.2.0
  checkOK


  cordova plugin add https://github.com/gbenvenuti/cordova-plugin-screen-orientation.git#baa4c2e0ed68fe58e7aa89f6c8beb707012c6426
  checkOK

  cordova plugin add https://github.com/driftyco/ionic-plugin-keyboard.git#9b7c416effe392d62b4ff99cd1b931ca3b5a710e
  checkOK

fi

if $DBGJS
then
  echo "${OpenColor}${Green}* Generating copay bundle (debug js)...${CloseColor}"
  cd $BUILDDIR/..
  grunt
  checkOK
else
  echo "${OpenColor}${Green}* Generating copay bundle...${CloseColor}"
  cd $BUILDDIR/..
  grunt prod
  checkOK
fi

echo "${OpenColor}${Green}* Copying files...${CloseColor}"
cd $BUILDDIR/..
cp -af public/** $PROJECT/www
checkOK

sed "s/<\!-- PLACEHOLDER: CORDOVA SRIPT -->/<script type='text\/javascript' charset='utf-8' src='cordova.js'><\/script>/g" public/index.html > $PROJECT/www/index.html
checkOK

cd $BUILDDIR

cp config.xml $PROJECT/config.xml
checkOK

if [ $CURRENT_OS == "ANDROID" ]; then
  echo "Android project!!!"

  mkdir -p $PROJECT/platforms/android/res/xml/
  checkOK

#  cp android/AndroidManifest.xml $PROJECT/platforms/android/AndroidManifest.xml
#  checkOK

  cp android/build-extras.gradle $PROJECT/platforms/android/build-extras.gradle
  checkOK

  cp android/project.properties $PROJECT/platforms/android/project.properties
  checkOK

  mkdir -p $PROJECT/scripts
  checkOK

  cp scripts/* $PROJECT/scripts
  checkOK

  cp -R android/res/* $PROJECT/platforms/android/res
  checkOK
fi

if [ $CURRENT_OS == "WP8" ]; then
  echo "Wp8 project!!!"
  cp -R $PROJECT/www/* $PROJECT/platforms/wp8/www
  checkOK
  if ! $CLEAR
  then
    cp -vf wp/Properties/* $PROJECT/platforms/wp8/Properties/
    checkOK
    cp -vf wp/MainPage.xaml $PROJECT/platforms/wp8/
    checkOK
    cp -vf wp/Package.appxmanifest $PROJECT/platforms/wp8/
    checkOK
    cp -vf wp/Assets/* $PROJECT/platforms/wp8/Assets/
    cp -vf wp/SplashScreenImage.jpg $PROJECT/platforms/wp8/
    cp -vf wp/ApplicationIcon.png $PROJECT/platforms/wp8/
    cp -vf wp/Background.png $PROJECT/platforms/wp8/
    checkOK
  fi
fi
