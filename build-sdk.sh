#!/bin/bash
umask 0022
source ./poky/oe-init-build-env
bitbake -c populate_sdk core-image-base-moco
