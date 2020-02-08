#!/bin/bash
umask 0022
source ./poky/oe-init-build-env
bitbake core-image-base-moco
