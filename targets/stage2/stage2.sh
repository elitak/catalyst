# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo/src/catalyst/targets/stage2/Attic/stage2.sh,v 1.3 2003/10/30 06:21:08 drobbins Exp $

case $1 in
enter)
	$clst_CHROOT $clst_chroot_path
	;;
run)
	$clst_CHROOT $clst_chroot_path /bin/bash << EOF
	env-update
	source /etc/profile
	cat /etc/make.profile/make.defaults | grep GRP_STAGE23_USE > /tmp/stage23
	source /tmp/stage23
	export USE="-* \${clst_HOSTUSE} \${GRP_STAGE23_USE}"
	echo
	echo "USE variables active: \${USE}"
	rm -f /tmp/stage23
	echo
	if [ -n "${clst_CCACHE}" ]
	then
		export FEATURES="ccache"	
		emerge --oneshot --nodeps ccache || exit 1
	fi
	if [ -n "${clst_PKGCACHE}" ]
	then
		export EMERGE_OPTS="--usepkg --buildpkg"
	fi
	/usr/portage/scripts/bootstrap.sh || exit 1
EOF
	[ $? -ne 0 ] && exit 1 
	;;
clean)
	# we need to have catalyst un-bind-mount things before
	# we clean up.
	$clst_CHROOT $clst_chroot_path /bin/bash << EOF
	env-update
	source /etc/profile
	if [ -n "${clst_CCACHE}" ]
	then
		emerge -C dev-util/ccache || exit 1
	fi
EOF
	[ $? -ne 0 ] && exit 1 
	;;
*)
	exit 1
	;;
esac
exit 0