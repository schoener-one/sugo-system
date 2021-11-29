#!/bin/bash
IMAGE=./build/tmp/deploy/images/raspberrypi3/core-image-base-sugo-raspberrypi3.rpi-sdimg
SD_MEM=/dev/mmcblk0
if ! [[ -f "$IMAGE" ]]; then
  echo "error: image not found: $IMAGE"
  exit
fi
if ! [[ -b "$SD_MEM" ]]; then
  echo "error: memory card not found"
  exit
fi
dd if="$IMAGE" of="$SD_MEM" bs=10M
