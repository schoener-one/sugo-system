# Sugo System

Sugo is an example Yocto project which runs on Raspberry Pi 3 hardware.
The system is used to run the [Sugo machine application](https://github.com/schoener-one/sugo-machine-application).

## Requirements

* Python
* KAS Python library (>=4.1)
* docker
* Raspberry Pi 3 or CM3 hardware
* bmap-tools (for image flashing)
  
## Build

The Raspberry Pi image is created by a bitbake (Yocto) build process. For convenience reasons, the **[KAS](https://pypi.org/project/kas/)** bitbake configuration and build management tool is used. Since the Yocto build usually requires a special environment configuration with required tools, we will use the **KAS** Docker container build environment.

```bash
python -m pip install kas
curl https://raw.githubusercontent.com/siemens/kas/kas-container -o kas-container
chmod 0755 kas-container
```

Before you start the build, please configure the appropriate root password within
_'sugo-system.yml'_ file by setting the appropriate value to the `ROOT_PASSWORD` variable!

After **KAS** was successfully installed, you could simply start the image build process with the following command. During that process, the tools will fetch different files and packages from internet repositories and download them to your local space. Afterwards all needed binaries will be build as well as the kernel. Finally, all artefacts are packed into the system image.

```bash
kas-container build sugo-system.yml
```

If you want to build the **SDK**, you have to run the following command as well.

```bash
kas-container build sugo-system.yml -c populate_sdk
```

> **_NOTE:_**  Due to missing privileges of the running container environment, it could be possible that the container has to be started with the docker option `--privileged`!

```bash
kas-container --runtime-args '--privileged' build sugo-system.yml
```

If the images has been built successfully, you can directly flash the image to the SD-Card by calling the `bmaptool`.

```
sudo bmaptool copy --bmap build/tmp/deploy/images/raspberrypi3/sugo-system-image-raspberrypi3.wic.bmap build/tmp/deploy/images/raspberrypi3/sugo-system-image-raspberrypi3.wic.bz2 /dev/sdb
```

## License

Distributed under the GPLv3 License. See [LICENSE](LICENSE) for more information.