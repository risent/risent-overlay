# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
DESCRIPTION="A gtk GUI to change fcitx config"
HOMEPAGE="http://code.google.com/p/fcitx"
SRC_URI="http://fcitx.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=app-i18n/fcitx-4.0.0
	dev-libs/glib
	x11-libs/gtk+"
RDEPEND="${DEPEND}"

src_install(){
	emake DESTDIR="${D}" install
}
