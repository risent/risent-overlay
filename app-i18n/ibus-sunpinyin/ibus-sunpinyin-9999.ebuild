# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# by Hubert Star
# $Header: $

EAPI="2"

inherit autotools python mercurial

DESCRIPTION="SunPinyin is a SLM (Statistical Language Model) based IME"
HOMEPAGE="http://code.google.com/p/ibus-sunpinyin/"
EHG_PROJECT="${PN##ibus-}"
EHG_REPO_URI="ssh://anon@hg.opensolaris.org/hg/nv-g11n/inputmethod"

LICENSE="LGPL-2.1 CDDL"
SLOT="0"
KEYWORDS=""
IUSE="debug"

RDEPEND="x11-libs/gtk+
	>=dev-libs/glib-2
	>=app-i18n/ibus-1.2
	>=dev-lang/python-2.6"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	sys-devel/gettext"
	
SRC_URI=""

S=${WORKDIR}/inputmethod/sunpinyin2

src_prepare() {
	(. ./autogen.sh) || die "autogen.sh failed"
}

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
