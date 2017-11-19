#! /bin/bash

set -x
set -e

qmake CONFIG+=release -recursive
make INSTALL_ROOT=AppDir -j$(nproc) install

# inspect AppDir -- TODO: remove this line before release
tree AppDir

mkdir -p AppDir/usr/share/{applications,icons/hicolor/256x256}
cp scripts/mumble.desktop AppDir/usr/share/applications/
# TODO: add real icon
touch AppDir/usr/share/icons/hicolor/256x256/mumble.png

wget -nv "https://github.com/probonopd/linuxdeployqt/releases/download/continuous/linuxdeployqt-continuous-x86_64.AppImage"

chmod +x linuxdeployqt-continuous-x86_64.AppImage

# fix environment
unset QTDIR
unset QT_PLUGIN_PATH
unset LD_LIBRARY_PATH

# add Git commit ID to AppImage filename
export VERSION=$(git rev-parse --short HEAD)
./linuxdeployqt-continuous-x86_64.AppImage AppDir/usr/share/applications/mumble.desktop -bundle-non-qt-libs
./linuxdeployqt*.AppImage ./appdir/usr/share/applications/*.desktop -appimage
