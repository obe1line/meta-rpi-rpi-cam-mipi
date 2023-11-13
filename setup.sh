#============================
# create the base directories
#============================
mkdir -p sources
mkdir -p build/conf

#=========================
# create the activate file
#=========================
[ ! -f "activate.sh" ] && cat <<< '#!/bin/bash
OEROOT=$PWD/sources/poky
echo "OEROOT = $OEROOT"
. $OEROOT/oe-init-build-env $PWD/build
' > activate.sh

#=========================
# create the local.bb file
#=========================
[ ! -f "build/conf/local.conf" ] && cat <<< '
MACHINE ?= "raspberrypi4-64"
IMAGE_FSTYPES = "tar.xz ext3 rpi-sdimg"
DISTRO ?= "poky"
PACKAGE_CLASSES ?= "package_deb"
EXTRA_IMAGE_FEATURES ?= "debug-tweaks"

IMAGE_INSTALL:append = " i2c-tools"
IMAGE_INSTALL:append = " kernel-modules"

# Wifi/BT license
LICENSE_FLAGS_ACCEPTED = "synaptics-killswitch"

PATCHRESOLVE = "noop"
BB_DISKMON_DIRS ??= "\
    STOPTASKS,${TMPDIR},1G,100K \
    STOPTASKS,${DL_DIR},1G,100K \
    STOPTASKS,${SSTATE_DIR},1G,100K \
    STOPTASKS,/tmp,100M,100K \
    HALT,${TMPDIR},100M,1K \
    HALT,${DL_DIR},100M,1K \
    HALT,${SSTATE_DIR},100M,1K \
    HALT,/tmp,10M,1K"

# shared folder on NAS unit
DL_DIR="${HOME}/nas/yocto-shared-data/bitbake.downloads"

CONF_VERSION = "2"
' > build/conf/local.conf

#=========================
# create the bblayers file
#=========================
[ ! -f "build/conf/bblayers.conf" ] && cat <<< '
# POKY_BBLAYERS_CONF_VERSION is increased each time build/conf/bblayers.conf
# changes incompatibly
POKY_BBLAYERS_CONF_VERSION = "2"

BBPATH := "${TOPDIR}"
BBFILES ?= ""

SOURCES_PATH := "${TOPDIR}/../sources/"

BBLAYERS ?= ""
BBLAYERS:append = " ${SOURCES_PATH}/poky/meta "
BBLAYERS:append = " ${SOURCES_PATH}/poky/meta-poky "
BBLAYERS:append = " ${SOURCES_PATH}/poky/meta-yocto-bsp "
BBLAYERS:append = " ${SOURCES_PATH}/meta-raspberrypi "
BBLAYERS:append = " ${SOURCES_PATH}/meta-rpi4-rpi-cam-mipi "
' > build/conf/bblayers.conf

#=======================
# clone the repositories
#=======================
pushd sources > /dev/null
[ ! -d "poky" ] && git clone https://git.yoctoproject.org/poky --depth=1 --branch=master
[ ! -d "meta-raspberrypi" ] && git clone https://github.com/agherzan/meta-raspberrypi --depth=1 --branch=master
popd > /dev/null

#====================
# show some help text
#====================
echo "*********************************************************"
echo " Activate the environment:  . ./activate.sh"
echo " Build:                     bitbake core-image-base"
echo "*********************************************************"
