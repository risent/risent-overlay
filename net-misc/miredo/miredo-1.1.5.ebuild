# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

inherit eutils

DESCRIPTION="Teredo IPv6 tunneling"
HOMEPAGE="http://www.remlab.net/miredo/"
SRC_URI="http://www.remlab.net/files/miredo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""
DEPEND="dev-libs/judy"

src_compile() {
	econf --enable-miredo-user --localstatedir=/var --docdir="/usr/share/doc/${P}" || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	newinitd "${FILESDIR}"/miredo.rc miredo
	newconfd "${FILESDIR}"/miredo.conf miredo
	newinitd "${FILESDIR}"/miredo-server.rc miredo-server
	newconfd "${FILESDIR}"/miredo-server.conf miredo-server
	newinitd "${FILESDIR}"/isatapd.rc isatapd
	newconfd "${FILESDIR}"/isatapd.conf isatapd
	emake DESTDIR="${D}" install || die "failed install"
	dodoc README NEWS ChangeLog AUTHORS THANKS TODO
}

pkg_preinst() {
	enewgroup miredo
	enewuser miredo -1 -1 /var/empty miredo
}
