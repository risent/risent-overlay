# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

ESVN_REPO_URI="http://fcitx.googlecode.com/svn/trunk"
ESVN_BOOTSTRAP='autogen.sh'
inherit subversion

DESCRIPTION="Free Chinese Input Toy for X. Another Chinese XIM Input Method"
HOMEPAGE="http://fcitx.googlecode.com"
SRC_URI="${HOMEPAGE}/files/pinyin.tar.gz
		${HOMEPAGE}/files/pinyin.tar.gz.md5
		${HOMEPAGE}/files/table.tar.gz
		${HOMEPAGE}/files/table.tar.gz.md5"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="dbus debug +pango"

RDEPEND="media-libs/fontconfig
	x11-libs/cairo
	x11-libs/libX11
	x11-libs/libXrender
	dbus? ( sys-apps/dbus )
	pango? ( x11-libs/pango )"
DEPEND="${RDEPEND}
	dev-util/intltool
	dev-util/pkgconfig
	sys-devel/gettext
	x11-proto/xproto"

src_unpack() {
	subversion_src_unpack
	cp "${DISTDIR}"/pinyin.tar.gz "${S}"/data
	cp "${DISTDIR}"/pinyin.tar.gz.md5 "${S}"/data
	cp "${DISTDIR}"/table.tar.gz "${S}"/data/table
	cp "${DISTDIR}"/table.tar.gz.md5 "${S}"/data/table
}

src_compile() {
	econf --enable-tray=yes --enable-recording=yes \
	$(use_enable dbus) \
	$(use_enable debug) \
	$(use_enable pango)
}

src_install() {
	emake DESTDIR="${D}" install || die "Install failed"
	dodoc AUTHORS ChangeLog README THANKS TODO || die "dodoc failed"
	rm -rf "${D}"/usr/share/fcitx/doc || die
	dodoc doc/cjkvinput.txt doc/fcitx4.pdf doc/pinyin.txt
	dohtml doc/wb_fh.htm || die "dothml failed"
}

pkg_postinst() {
	einfo "This is not an official release. Please report you bugs to:"
	einfo "http://code.google.com/p/fcitx/issues/list"
	echo
	elog "You should export the following variables to use fcitx"
	elog " export XMODIFIERS=\"@im=fcitx\""
	elog " export XIM=\"fcitx\""
	elog " export GTK_IM_MODULE=\"fcitx\""
	elog " export QT_IM_MODULE=\"fcitx\""
}
