# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# by Hubert Star
# $Header: $

EAPI="2"

inherit autotools python

DESCRIPTION="SunPinyin is a SLM (Statistical Language Model) based IME"
HOMEPAGE="http://code.google.com/p/ibus-sunpinyin/"

LICENSE="LGPL-2.1 CDDL"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="debug"

RDEPEND="x11-libs/gtk+
	>=dev-libs/glib-2
	>=app-i18n/ibus-1.0
	>=dev-lang/python-2.5"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	sys-devel/gettext"
	
SRC_URI="http://ibus-sunpinyin.googlecode.com/files/sunpinyin-${PV}.tar.gz"

S=${WORKDIR}/sunpinyin-2.0

src_configure() {
	econf \
		$(use_enable debug) \
		--enable-ibus
}

src_install() {
	emake install DESTDIR="${D}" || die "Install failed"
}


pkg_postinst() {
    python_mod_optimize /usr/share/ibus-sunpinyin/setup
}

pkg_postrm() {
    python_mod_cleanup /usr/share/ibus-sunpinyin/setup
}
