#!/bin/bash

source /tmp/chroot-functions.sh

# Setup the environment
export DESTROOT="${clst_root_path}"
export clst_root_path="/"

setup_pkgmgr

shopt -s nocasematch
case "${clst_embedded_nodeps}" in
    true | yes | [1-9]*)
        # The strategy here is to install all the dependencies in the regular
        # root, then only the explicitly listed packages into mergeroot;
        # everything outside of mergeroot is discarded.
        echo "Installing dependencies for ${DESTROOT} into ${clst_root_path}..."
        run_merge -o "${clst_embedded_packages}"
        export clst_root_path="${DESTROOT}"
        export INSTALL_MASK="${clst_install_mask}"
        echo "Installing explicit list of packages into ${clst_root_path}..."
        # TODO how to include runtime deps that are libs here?
        run_merge -1 -O "${clst_embedded_packages}"
        ;;
    *)
        export clst_root_path="${DESTROOT}"
        export INSTALL_MASK="${clst_install_mask}"
        # FIXME this usually fails, trying to install too many deps
        run_merge -1 "${clst_embedded_packages}"
        ;;
esac
