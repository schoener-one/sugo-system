#!/bin/bash
set -e
BASE_DIR=$(dirname $0)

read_json()
{
    cat $BASE_DIR/project.json |tr -d '\n' |sed "s/.*\"$1\":[^\"]*\"\\([^\"]*\\)\".*/\\1/g"
}
PROJECT_NAME=$(read_json "name")
SYSTEM_VERSION=$(read_json "version")
SYSTEM_IMAGE=$(read_json "image")

export BB_ENV_EXTRAWHITE="$BB_ENV_EXTRAWHITE DL_DIR SSTATE_DIR"
BUILD_REVISION=$(git log -1 --pretty=format:"%h")
BUILD_VERSION=
MANIFEST_FILE=manifest.json

build_image()
{
    echo "###############################################"
    echo "Build image '$SYSTEM_IMAGE'..."
    umask 0022
    source ./poky/oe-init-build-env
    bitbake "$SYSTEM_IMAGE" || exit 1
}

build_sdk()
{
    echo "###############################################"
    echo "Build image '$SYSTEM_IMAGE' SDK..."
    umask 0022
    source ./poky/oe-init-build-env
    bitbake -c populate_sdk "$SYSTEM_IMAGE" || exit 1
}

build_all()
{
    build_image
    build_sdk
}

write_manifest()
{
    cat << EOF > manifest.json
{
    "project": "$PROJECT_NAME",
    "version": "$SYSTEM_VERSION",
    "build" : {
        "revision": "$BUILD_REVISION",
        "version": "$BUILD_VERSION" 
    }
}
EOF
}

pack_artifacts()
{
    echo "###############################################"
    echo "Build image package..."
    write_manifest
    BUILD_VERSION=$1
    shift
    TAR_FILE="${PROJECT_NAME}-${SYSTEM_VERSION}-${BUILD_REVISION}.${BUILD_VERSION}.tar"
    tar -cvhf "$TAR_FILE" "$MANIFEST_FILE"
    for _FILE in $@; do
        _FILE_DIR=$(dirname "$_FILE")
        _FILE_NAME=$(basename "$_FILE")
        tar -rvhf "$TAR_FILE" -C "$_FILE_DIR" "$_FILE_NAME"
    done
    gzip -f "$TAR_FILE"
}

DO_PACK_ARTIFACTS=false

while getopts "absf:p:" OPT; do
    case "$OPT" in
      a)
        build_all
        ;;
      b)
        build_image
        ;;
      s)
        build_sdk
        ;;
      p)
        BUILD_VERSION="$OPTARG"
        declare -a PACK_ARTIFACTS
        DO_PACK_ARTIFACTS=true
        ;;
      f)
        PACK_ARTIFACTS+=("$OPTARG")
        ;;
      [?])
        # got invalid option
        echo "Usage: $0 [-abs] [-p <build-version-tag> [<artifact>]]" >&2
        exit 1 ;;
    esac
done

# get rid of the just-finished flag arguments
shift $(($OPTIND-1))

if $DO_PACK_ARTIFACTS; then
    pack_artifacts $BUILD_VERSION "${PACK_ARTIFACTS[@]}"
fi
