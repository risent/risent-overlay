# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit subversion

DESCRIPTION="Google Gears for Firefox"
HOMEPAGE="http://code.google.com/p/gears/"

ESVN_REPO_URI="http://gears.googlecode.com/svn/trunk/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

S="${WORKDIR}/gears-trunk"

src_prepare() {
	epatch "${FILESDIR}/r3405.patch"
}

src_compile() {
	cd "${S}/gears"

	# HACK: override internal xpidl with a 64-bit version
	rm ../third_party/gecko_1.9.1/linux/gecko_sdk/bin/xpidl && ln -s /usr/lib64/xulrunner-[0-9]*/xpidl ../third_party/gecko_1.9.1/linux/gecko_sdk/bin/xpidl || die "could not set up 64-bit xpidl"
	rm ../third_party/gecko_1.9/linux/gecko_sdk/bin/xpidl && ln -s /usr/lib64/xulrunner-[0-9]*/xpidl ../third_party/gecko_1.9/linux/gecko_sdk/bin/xpidl || die "could not set up 64-bit xpidl"
	emake MODE=opt OS=linux ARCH=x86_64
	# HACK: build fails the first time due to NS_OUTPARAM. We can remove this on most systems, afaict.
	sed -i 's|NS_OUTPARAM||' bin-opt/linux-x86_64/ff3/genfiles/interfaces.h
	emake MODE=opt OS=linux ARCH=x86_64 || die "emake failed"
}

src_install() {
	insinto /opt/google-gears
	# Meh. I wish there was an automated way to get Firefox to recognize and install this.
	xpifile="$(ls ${S}/gears/bin-opt/installers/*.xpi)"
	doins "${xpifile}" || die "failed to install XPI files"

	elog "The plugin installer has been placed in /opt/google-gears."
	elog "Open it in Firefox by selecting File -> Open File..."
}
