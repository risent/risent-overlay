# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit eutils

DESCRIPTION="Chromium is the open-source project behind Google Chrome."
HOMEPAGE="http://code.google.com:80/chromium/"

LV="${PV}"
if [[ "${PV}" == "99999" ]] ; then
	LV=`curl http://build.chromium.org/buildbot/snapshots/chromium-rel-linux/LATEST`
	einfo "The latest version is ${LV}"
fi

SRC_URI="http://build.chromium.org/buildbot/snapshots/chromium-rel-linux/${LV}/chrome-linux.zip -> ${PN}-${LV}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

IUSE=""

DEPEND="
	>=dev-lang/python-2.4
	>=dev-libs/nss-3.12
	x11-libs/gtk+:2
	media-fonts/corefonts
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/chromium"

src_install() {
	declare CHROMIUM_HOME=/opt/chromium.org/

	dodir ${CHROMIUM_HOME}
	mv ${WORKDIR}/chrome-linux/ "${D}"${CHROMIUM_HOME}
	
	# Create symbol links for necessary libraries
	dosym /usr/lib/libnspr4.so /usr/lib/libnspr4.so.0d
	dosym /usr/lib/libnss3.so /usr/lib/libnss3.so.1d
	dosym /usr/lib/libnssutil3.so /usr/lib/libnssutil3.so.1d
	dosym /usr/lib/libplc4.so /usr/lib/libplc4.so.0d
	dosym /usr/lib/libplds4.so /usr/lib/libplds4.so.0d

	dosym /usr/lib/libsmime3.so /usr/lib/libsmime3.so.1d
	dosym /usr/lib/libssl3.so /usr/lib/libssl3.so.1d

	# Create /usr/bin/chromium-bin
	dodir /usr/bin/
	cat <<EOF >"${D}"/usr/bin/chromium-bin
#!/bin/sh
unset LD_PRELOAD
exec /opt/chromium.org/chrome-linux/chrome "\$@"
EOF
	fperms 0755 "/usr/bin/chromium-bin"
	newicon ${FILESDIR}/chromium.png ${PN}.png
	make_desktop_entry chromium-bin "Google Chrome" ${PN}.png "Network;WebBrowser"
}

