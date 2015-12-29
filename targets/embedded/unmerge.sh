
${clst_CHROOT} ${clst_chroot_path} /bin/bash << EOF
	ROOT=${clst_mergeroot} emerge -C $* || exit 1
EOF
