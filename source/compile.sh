# Create necessary directories and clone repository
mkdir -p /UGREENLEDS/lib/modules/${UNAME}/extra
cd ${DATA_DIR}
git clone https://github.com/miskcoo/ugreen_dx4600_leds_controller
cd ${DATA_DIR}/ugreen_dx4600_leds_controller
git checkout master
PLUGIN_VERSION="$(git log -1 --format="%cs" | sed 's/-//g')"

# Compile module and copy it over to destination
cd ${DATA_DIR}/ugreen_dx4600_leds_controller/kmod
make -j${CPU_COUNT}
cp ${DATA_DIR}/ugreen_dx4600_leds_controller/kmod/led-ugreen.ko /UGREENLEDS/lib/modules/${UNAME}/extra/

#Compress module
while read -r line
do
  xz --check=crc32 --lzma2 $line
done < <(find /UGREENLEDS/lib/modules/${UNAME}/extra -name "*.ko")

#Copy over ugreen-diskiomon
cp ${DATA_DIR}/ugreen_dx4600_leds_controller/scripts/ugreen-diskiomon /UGREENLEDS/usr/bin/ugreen-diskiomon

# Create Slackware Package
PLUGIN_NAME="ugreen_leds"
BASE_DIR="/UGREENLEDS"
TMP_DIR="/tmp/${PLUGIN_NAME}_"$(echo $RANDOM)""
VERSION="$(date +'%Y.%m.%d')"
mkdir -p $TMP_DIR/$VERSION
cd $TMP_DIR/$VERSION
cp -R $BASE_DIR/* $TMP_DIR/$VERSION/
mkdir $TMP_DIR/$VERSION/install
tee $TMP_DIR/$VERSION/install/slack-desc <<EOF
       |-----handy-ruler------------------------------------------------------|
$PLUGIN_NAME: $PLUGIN_NAME Package contents:
$PLUGIN_NAME:
$PLUGIN_NAME: Source: https://github.com/miskcoo/ugreen_dx4600_leds_controller
$PLUGIN_NAME:
$PLUGIN_NAME:
$PLUGIN_NAME: Custom $PLUGIN_NAME package for Unraid Kernel v${UNAME%%-*} by ich777
$PLUGIN_NAME:
EOF
${DATA_DIR}/bzroot-extracted-$UNAME/sbin/makepkg -l n -c n $TMP_DIR/$PLUGIN_NAME-$PLUGIN_VERSION-$UNAME-1.txz
md5sum $TMP_DIR/$PLUGIN_NAME-$PLUGIN_VERSION-$UNAME-1.txz | awk '{print $1}' > $TMP_DIR/$PLUGIN_NAME-$PLUGIN_VERSION-$UNAME-1.txz.md5
