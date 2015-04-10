#! /bin/sh

# Check number of parameters
if [ $# -ne 1 ]; then
	echo "usage : $0 <version>"
	exit
fi

BASE_DIR=$(pwd)
VERSION=$1

# Check for correct version parameter
if [ ! -d "$BASE_DIR/versions/$VERSION" ]; then
	echo "Unknown version specified, available versions:"
	DIRECTORIES=( $(find $BASE_DIR/versions -maxdepth 1 -type d -printf '%P\n') )
	for version in "${DIRECTORIES[@]}";
	do
		echo "$version"
	done
	exit
fi

DIRECTORIES=( $(find $BASE_DIR/versions/$VERSION -maxdepth 1 -type d -printf '%P\n') )
# loop for all repositories
for repo in "${DIRECTORIES[@]}";
do
	# Check if repository already exists
	if [ -d "$BASE_DIR/$repo" ]; then
		echo "Repository $repo already exists, skipping..."
		continue
	fi

	# Get SRC_URI
	if [ -f "$BASE_DIR/versions/$VERSION/$repo/SRC_URI" ]; then
		SRC_URI=$(cat $BASE_DIR/versions/$VERSION/$repo/SRC_URI)
	else
		echo "No SRC_URI for $repo, skipping..."
		continue
	fi

	# Get SRC_REV
	if [ -f "$BASE_DIR/versions/$VERSION/$repo/SRC_REV" ]; then
		SRC_REV=$(cat $BASE_DIR/versions/$VERSION/$repo/SRC_REV)
	else
		echo "No SRC_REV for $repo, skipping..."
		continue
	fi

	# Clone repository
	echo "Cloning $repo from ($SRC_URI)"
	git clone -q $SRC_URI $repo

	# Check if repository has been cloned
	if [ -d "$BASE_DIR/$repo" ]; then
		cd $BASE_DIR/$repo

		# Checkout the required revision
		echo "Checking out revision $SRC_REV"
		git checkout -q $SRC_REV

		# Check if any patches need to be applied
		if [ -d "$BASE_DIR/versions/$VERSION/$repo/patches" ]; then
			# Apply patches
			echo "Applying patches to $repo"
			git am -q $BASE_DIR/versions/$VERSION/$repo/patches/*.patch
		fi

		cd "$BASE_DIR"
	fi
done
