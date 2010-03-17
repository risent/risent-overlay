# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit autotools python git
MY_PN="${PN##ibus-}"
EGIT_PROJECT="${MY_PN}"
EGIT_REPO_URI="git://github.com/sunpinyin/sunpinyin.git" 
DESCRIPTION="SunPinyin is a SLM (Statistical Language Model) based IME"
HOMEPAGE="http://sunpinyin.org"
SRC_URI=""

LICENSE="LGPL-2.1 CDDL"
SLOT="0"
KEYWORDS="amd64"
IUSE="debug"

RDEPEND="x11-libs/gtk+
	>=dev-libs/glib-2
	>=app-i18n/ibus-1.2.0
	!app-i18n/scim-sunpinyin
	>=dev-lang/python-2.6"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	sys-devel/gettext"

#S=${WORKDIR}/${MY_PN}2

src_prepare() {
	(./autogen.sh) || die "autogen.sh failed"
}

src_configure() {
	econf \
		$(use_enable debug) \
		--enable-ibus
}

#src_compile() {
	#local myconf

	#myconf="${myconf} --enable-ibus"
	#econf $myconf} || die
	#emake || die 
#}

src_install() {
	emake install DESTDIR="${D}" || die "Install failed"
}

pkg_postinst() {
	python_mod_optimize /usr/share/ibus-sunpinyin/setup
}

pkg_postrm() {
	python_mod_cleanup /usr/share/ibus-sunpinyin/setup
}
