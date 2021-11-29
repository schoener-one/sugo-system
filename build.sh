#!/bin/bash
set -e
BASE_DIR=$(dirname $0)

read_json()
{
    cat $BASE_DIR/project.json |tr -d '\n' |sed "s/.*\"$1\":[^\"]*\"\\([^\"]*\\)\".*/\\1/g"
}
export BB_ENV_EXTRAWHITE="$BB_ENV_EXTRAWHITE \
  DL_DIR SSTATE_DIR \
  SUGO_SYSTEM_VERSION \
  SUGO_BUILD_REVISION \
  ROOT_PASSWORD \
  SUGO_SYSTEM_ONLY_BUILD"
PROJECT_NAME=$(read_json "name")
SYSTEM_IMAGE=$(read_json "image")
export SUGO_SYSTEM_VERSION=$(read_json "version")
export SUGO_BUILD_REVISION=$(git log -1 --pretty=format:"%h")
BUILD_VERSION=
MANIFEST_FILE=manifest.json
ARTIFACT_DO_PACK=false
ARTIFACT_IMAGE=
ARTIFACT_SDK=

prepare_cache()
{
  if [ -n "$DL_DIR" ] && ! [ -d "$DL_DIR" ]; then mkdir -p "$DL_DIR"; fi
  if [ -n "$SSTATE_DIR" ] && ! [ -d "$SSTATE_DIR" ]; then mkdir -p "$SSTATE_DIR"; fi
}

build_image()
{
    echo "###############################################"
    echo "Build image '$SYSTEM_IMAGE'..."
    prepare_cache
    umask 0022
    source ./poky/oe-init-build-env
    bitbake "$SYSTEM_IMAGE" || exit 1
}

build_sdk()
{
    echo "###############################################"
    echo "Build image '$SYSTEM_IMAGE' SDK..."
    prepare_cache
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
    "version": "$SUGO_SYSTEM_VERSION",
    "build" : {
        "revision": "$SUGO_BUILD_REVISION",
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
    TAR_FILE="${PROJECT_NAME}-${SUGO_SYSTEM_VERSION}-${SUGO_BUILD_REVISION}.${BUILD_VERSION}.tar"
    tar -cvhf "$TAR_FILE" "$MANIFEST_FILE"
    for _FILE in $@; do
        _FILE_DIR=$(dirname "$_FILE")
        _FILE_NAME=$(basename "$_FILE")
        tar -rvhf "$TAR_FILE" -C "$_FILE_DIR" "$_FILE_NAME"
    done
    gzip -f "$TAR_FILE"
}

while getopts "absf:i:p:" OPT; do
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
        ARTIFACT_DO_PACK=true
        ;;
      i)
        ARTIFACT_IMAGE=("$OPTARG")
        ;;
      f)
        ARTIFACT_SDK=("$OPTARG")
        ;;
      [?])
        # got invalid option
        echo "Usage: $0 [-abs] [-p <build-version-tag> [<artifact>]]" >&2
        exit 1 ;;
    esac
done

# get rid of the just-finished flag arguments
shift $(($OPTIND-1))

if $ARTIFACT_DO_PACK; then
    pack_artifacts $BUILD_VERSION "${ARTIFACT_IMAGE}" "${ARTIFACT_SDK}"
fi
