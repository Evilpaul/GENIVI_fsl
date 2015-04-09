#! /bin/sh

# Check number of parameters
if [ $# -ne 1 ]; then
	echo "usage : $0 <version>"
	exit
fi

##############################################################################
# Repository information
##############################################################################

SRC_NAME[0]="poky"
SRC_URI[0]="http://git.yoctoproject.org/git/poky"
SRC_REV_7[0]="9fc095a439c36014c73b3a8f240afba09fe0e4d7"
SRC_REV_8[0]="6dd21a9f152a93e2df1178d7a5bd903d7edcf4be"

SRC_NAME[1]="meta-fsl-arm"
SRC_URI[1]="http://git.yoctoproject.org/git/meta-fsl-arm"
SRC_REV_7[1]="64752fbb49b16cad881a7b4d35fef3f8315a673f"
SRC_REV_8[1]="db1571f40c375a398a8cdbb42de4c4f272ab0cd1"

SRC_NAME[2]="meta-ivi"
SRC_URI[2]="http://git.yoctoproject.org/git/meta-ivi"
SRC_REV_7[2]="054f6ca8f17c2387d45049db5ac9450efe2f787b"
SRC_REV_8[2]="3a619f09239276dafca21f521fdbffae226b6e0e"

SRC_NAME[3]="meta-qt5"
SRC_URI[3]="https://github.com/meta-qt5/meta-qt5.git"
SRC_REV_7[3]="1cec680ca9bcd00caaede8fa3d0ff3a4317550dc"
SRC_REV_8[3]="1cec680ca9bcd00caaede8fa3d0ff3a4317550dc"

SRC_NAME[4]="meta-openembedded"
SRC_URI[4]="https://github.com/openembedded/meta-oe.git"
SRC_REV_7[4]="9efaed99125b1c4324663d9a1b2d3319c74e7278"
SRC_REV_8[4]="853dcfa0d618dc26bd27b3a1b49494b98d6eee97"

SRC_NAME[5]="meta-fsl-ivi"
SRC_URI[5]="https://github.com/Freescale/meta-fsl-ivi.git"
SRC_REV_7[5]="671bcd8e588b0b1ee011184c08af834ac0bed616"
SRC_REV_8[5]="671bcd8e588b0b1ee011184c08af834ac0bed616"

SRC_NAME[6]="meta-fsl-arm-extra"
SRC_URI[6]="https://github.com/Freescale/meta-fsl-arm-extra.git"
SRC_REV_7[6]="373e77941ba9fc094b8a3fe56265972a4b76b9de"
SRC_REV_8[6]="373e77941ba9fc094b8a3fe56265972a4b76b9de"

##############################################################################

BASE_DIR=$(pwd)
VERSION=$1

# Check for correct version parameter
if [ "$VERSION" = "7.0" ]; then
	declare -a SRC_REV=( ${SRC_REV_7[@]} )
elif [ "$VERSION" = "8.0" ]; then
	declare -a SRC_REV=( ${SRC_REV_8[@]} )
else
	echo "Unknown version specified"
	exit
fi

# loop for all elements
for element in $(eval echo "{0..${#SRC_NAME[@]}}")
do
	# Check if repository already exists
	if [ -d "$BASE_DIR/${SRC_NAME[$element]}" ]; then
		echo "Repository ${SRC_NAME[$element]} already exists, skipping.."
		continue
	fi

	# Clone repository
	echo "Cloning ${SRC_NAME[$element]} from (${SRC_URI[$element]})"
	git clone "${SRC_URI[$element]}" "${SRC_NAME[$element]}"

	# Check if repository has been cloned
	if [ -d "$BASE_DIR/${SRC_NAME[$element]}" ]; then
		cd "$BASE_DIR/${SRC_NAME[$element]}"

		# Checkout the required revision
		echo "Checking out revision ${SRC_REV[$element]}"
		git checkout "${SRC_REV[$element]}"

		# Check if any patches need to be applied
		if [ -d "$BASE_DIR/patches/$VERSION/${SRC_NAME[$element]}" ]; then
			# Apply patches
			echo "Applying patches to ${SRC_NAME[$element]}"
			git am "$BASE_DIR/patches/$VERSION/${SRC_NAME[$element]}/*.patch"
		fi

		cd "$BASE_DIR"
	fi
done
