# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit eutils

DESCRIPTION="Free Chinese Input Toy for X. Another Chinese XIM Input Method"
HOMEPAGE="http://fcitx.googlecode.com"
SRC_URI="${HOMEPAGE}/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dbus +pango"

RDEPEND="x11-libs/cairo[X]
	x11-libs/libX11
	x11-libs/libXft
	x11-libs/libXrender
	pango? ( x11-libs/pango )
	dbus? ( >=sys-apps/dbus-0.2 )"
DEPEND="${RDEPEND}
	x11-proto/xproto
	dev-util/intltool
	sys-devel/gettext
	dev-util/pkgconfig"

src_prepare(){
	# fix QA issues, see http://code.google.com/p/fcitx/issues/detail?id=334
	epatch "${FILESDIR}/${P}-declare_DestroyTrayWindow.patch"
}

src_configure() {
	econf $(use_enable dbus)\
	$(use_enable pango)|| die
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	rm -rf "${D}"/usr/share/fcitx/doc/ || die
	dodoc AUTHORS ChangeLog README THANKS TODO \
			doc/pinyin.txt doc/cjkvinput.txt doc/fcitx4.pdf \
			|| die "dodoc failed"
	dohtml doc/wb_fh.htm || die "dohtml failed"
}

pkg_postinst() {
	elog
	elog "You should export the following variables to use fcitx"
	elog " export XMODIFIERS=\"@im=fcitx\""
	elog " export XIM=fcitx"
	elog " export XIM_PROGRAM=fcitx"
	elog
	elog "Refer to /usr/share/doc/${P}/fcitx4.pdf for more"
	elog "information and help."
	elog
}
