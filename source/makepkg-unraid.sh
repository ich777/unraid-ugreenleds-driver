#!/bin/bash
PLUGIN_NAME="ugreenleds-driver"
BASE_DIR="/usr/bin/ugreen-leds"
TMP_DIR="/tmp/${PLUGIN_NAME}_"$(echo $RANDOM)""
VERSION="$(date +'%Y.%m.%d')"

mkdir -p $TMP_DIR/$VERSION
cd $TMP_DIR/$VERSION
cp --parents -R $BASE_DIR $TMP_DIR/$VERSION/
chmod -R 755 $TMP_DIR/$VERSION/
makepkg -l y -c y $TMP_DIR/$PLUGIN_NAME-$VERSION.txz
md5sum $TMP_DIR/$PLUGIN_NAME-$VERSION.txz | awk '{print $1}' > $TMP_DIR/$PLUGIN_NAME-$VERSION.txz.md5
rm -R $TMP_DIR/$VERSION/
chmod -R 755 $TMP_DIR/*

#rm -R $TMP_DIR

