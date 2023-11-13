LINUX_VERSION ?= "6.1.54"
LINUX_RPI_BRANCH ?= "rpi-6.1.y"
LINUX_RPI_KMETA_BRANCH ?= "yocto-6.1"

SRC_URI = " \
    git://github.com/obe1line/rpi-linux.git;name=machine;branch=${LINUX_RPI_BRANCH};protocol=https \
    git://git.yoctoproject.org/yocto-kernel-cache;type=kmeta;name=meta;branch=${LINUX_RPI_KMETA_BRANCH};destsuffix=${KMETA} \
    file://rpi-cam-mipi.cfg \
    file://powersave.cfg \
    file://android-drivers.cfg \
    "


