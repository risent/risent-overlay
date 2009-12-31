# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit eutils multilib savedconfig toolchain-funcs

DESCRIPTION="Dynamic virtual terminal manager"
HOMEPAGE="http://www.brain-dump.org/projects/dvtm/"
SRC_URI="http://www.brain-dump.org/projects/dvtm/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sys-libs/ncurses[unicode]"

src_prepare() {
	sed -i \
		-e "/^PREFIX/s|=.*|= /usr|" \
		-e "s|-I/usr/local/include||" \
		-e "s|-L/usr/local/lib||" \
		-e "s|-L/usr/lib|-L/usr/$(get_libdir)|" \
		-e "s|-Os||" \
		-e "/^CC/s|=.*|= $(tc-getCC)|" \
		config.mk || die "sed config.mk failed"

	sed -i -e '/strip/d' Makefile || die "sed Makefile failed"

	use savedconfig && restore_config config.h
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	insinto /usr/share/${PN}
	newins config.h ${PF}.config.h

	dodoc README

	save_config config.h
}

pkg_postinst() {
	elog "This ebuild has support for user defined configs"
	elog "Please read this ebuild for more details and re-emerge as needed"
	elog "if you want to add or remove functionality for ${PN}"
}
