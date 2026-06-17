# Create necessary directories and clone repository
mkdir -p /UGREENLEDS/lib/modules/${UNAME}/extra
cd ${DATA_DIR}
git clone https://github.com/miskcoo/ugreen_dx4600_leds_controller
cd ${DATA_DIR}/ugreen_dx4600_leds_controller
# NOTE: DXP4800 GT support requires the chip-id-gated SMBus block-write framing
# in led-ugreen. That must be present on this ref or the GT's LEDs will read but
# not write. Tracking PR: miskcoo/ugreen_leds_controller#100 (AMD/DesignWare).
git checkout master
PLUGIN_VERSION="$(git log -1 --format="%cs" | sed 's/-//g')"

# Compile module and copy it over to destination
cd ${DATA_DIR}/ugreen_dx4600_leds_controller/kmod
make -j${CPU_COUNT}
cp ${DATA_DIR}/ugreen_dx4600_leds_controller/kmod/led-ugreen.ko /UGREENLEDS/lib/modules/${UNAME}/extra/

# AMD-based models (e.g. DXP4800 GT) need the Synopsys DesignWare I2C bus
# driver, which the stock Unraid kernel does not build. Compile it as a module
# from the prepared kernel source so the LED MCU's bus is available.
KERNEL_SRC="${DATA_DIR}/linux-${UNAME}"
if [ -d "${KERNEL_SRC}" ]; then
  ( cd "${KERNEL_SRC}"
    ./scripts/config --module CONFIG_I2C_DESIGNWARE_CORE \
                     --module CONFIG_I2C_DESIGNWARE_PLATFORM
    make olddefconfig
    make modules_prepare
    make M=drivers/i2c/busses -j${CPU_COUNT} \
      CONFIG_I2C_DESIGNWARE_CORE=m CONFIG_I2C_DESIGNWARE_PLATFORM=m modules )
  cp "${KERNEL_SRC}"/drivers/i2c/busses/i2c-designware-core.ko \
     "${KERNEL_SRC}"/drivers/i2c/busses/i2c-designware-platform.ko \
     /UGREENLEDS/lib/modules/${UNAME}/extra/
else
  echo "WARNING: kernel source ${KERNEL_SRC} not found; skipping DesignWare modules (DXP4800 GT will not work)"
fi

#Compress module
while read -r line
do
  xz --check=crc32 --lzma2 $line
done < <(find /UGREENLEDS/lib/modules/${UNAME}/extra -name "*.ko")

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
