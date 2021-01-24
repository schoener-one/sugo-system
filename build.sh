#!/bin/bash
umask 0022
source ./poky/oe-init-build-env
export BB_ENV_EXTRAWHITE="$BB_ENV_EXTRAWHITE DL_DIR SSTATE_DIR"

if bitbake core-image-base-moco; then
    bitbake -c populate_sdk core-image-base-moco
fi
