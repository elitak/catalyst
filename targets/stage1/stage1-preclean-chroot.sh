#!/bin/bash
# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo/src/catalyst/targets/stage1/stage1-preclean-chroot.sh,v 1.4 2005/04/14 14:59:48 rocket Exp $

. /tmp/chroot-functions.sh

# now, some finishing touches to initialize gcc-config....
unset ROOT

setup_gcc
		
# stage1 is not going to have anything in zoneinfo, so save our Factory timezone
if [ -d /usr/share/zoneinfo ] ; then
	rm -f /etc/localtime
	cp /usr/share/zoneinfo/Factory /etc/localtime
else
	echo UTC > /etc/TZ
fi

# this cleans out /var/db, but leaves behind files portage needs for removal
#find /var/db/pkg -type f | grep -v '\(COUNTER\|CONTENTS\|ebuild\)' | xargs rm -f