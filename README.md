Layer dependencies
=====================================================

See versions/<release>/<layer>


Build Genivi 7.0.3 p1 with Wayland IVI Extension
=====================================================

1. Export TEMPLATECONF to pick up correct configuration for the build
	export TEMPLATECONF=/full/path/to/meta-ivi/meta-ivi/conf

2. Source oe-init-build-env

	source poky/oe-init-build-env

3. Build image including GENIVI 7.0.3 P1 components and Wayland backend

	bitbake intrepid-image



Running Wayland test applications
=====================================================

1. Deploy rootfs image into and sdcard

	sudo dd if=intrepid-image.sdcard of=/dev/SDxx bs=4M && sync && sync

2. Place SD on imx6sabrelite and power on

3. Run test application
