Layer dependencies
=====================================================

URI: http://git.yoctoproject.org/git/poky
branch: dizzy
revision: 9fc095a439c36014c73b3a8f240afba09fe0e4d7

URI: http://git.yoctoproject.org/git/meta-fsl-arm
branch: dizzy
revision: 64752fbb49b16cad881a7b4d35fef3f8315a673f

URI: http://git.yoctoproject.org/git/meta-ivi
branch: 7.0
revision: 054f6ca8f17c2387d45049db5ac9450efe2f787b

URI: https://github.com/meta-qt5/meta-qt5.git
branch: dizzy
revision: 1cec680ca9bcd00caaede8fa3d0ff3a4317550dc

URI: https://github.com/openembedded/meta-oe.git
branch: dizzy
revision: 9efaed99125b1c4324663d9a1b2d3319c74e7278

URI: https://github.com/Freescale/meta-fsl-ivi.git
branch: 7.0
revision: 671bcd8e588b0b1ee011184c08af834ac0bed616

URI: https://github.com/Freescale/meta-fsl-arm-extra.git
branch: dizzy
revision: 373e77941ba9fc094b8a3fe56265972a4b76b9de



Build Genivi 7.0.3 p1 with Wayland IVI Extension
=====================================================

1. Export TEMPLATECONF to pick up correct configuration for the build
export TEMPLATECONF=/full/path/to/meta-ivi/meta-ivi/conf

2. Source oe-init-build-env

	source poky/oe-init-build-env

3. Add meta-fsl-arm, meta-fsl-arm-extra, meta-fsl-ivi and meta-qt5 layer
   dependency paths to COREBASE/build/conf/bblayers.conf in BBLAYERS
   variable.

4. Set MACHINE ?= "imx6qsabrelite" in COREBASE/build/conf/local.conf

5. Accept End User License Agrement to use prebuilt GPU binaries
   add in COREBASE/build/conf/local.conf

	ACCEPT_FSL_EULA = "1"

6. Build image including GENIVI 7.0.3 P1 components and Wayland backend

	bitbake intrepid-image



Running Wayland test applications
=====================================================

1. Deploy rootfs image into and sdcard

	sudo dd if=intrepid-image.sdcard of=/dev/SDxx bs=4M && sync && sync

2. Place SD on imx6sabrelite and power on

3. Run test application
