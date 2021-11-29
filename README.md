# Sugo System

Sugo System contains a complete embedded system
based on Yocto which contains the Sugo CoffeeAutomat application.

## Installation

Just start the Yocto build as follows:

```bash
./build.sh -b
```

## Using

Flash the whole image (e.g. 'build/tmp/deploy/images/raspberrypi3/core-image-base-sugo-raspberrypi3.rpi-sdimg')
into the flash memory of the target device (e.g. Raspberry PI 3)

## Contributing

The software is not allowed to be contributed for commercial intentions.

## License

CLOSED

## TODOs

* The initial call of systemd-firstboot starts interactive requests for
  locale language and time-zone settings. This has to be pre-configured
  at startup!
  
* GPIOs have to be setted up automatically on startup.

* I2C module has to be loaded automatically on startup (modprobe i2c-dev).
