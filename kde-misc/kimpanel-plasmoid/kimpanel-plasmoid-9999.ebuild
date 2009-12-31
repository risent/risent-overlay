# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit subversion kde4-base 

#ESVN_REPO_URI="svn://anonsvn.kde.org/home/kde/trunk/kdereview/plasma/applets/kimpanel"
ESVN_REPO_URI="svn://anonsvn.kde.org/home/kde/trunk/KDE/kdeplasma-addons/applets/kimpanel"


DESCRIPTION="IM Panel Plasmoid For KDE4.3,KDE From The Trunk Needed"
HOMEPAGE="http://websvn.kde.org/trunk/kdereview/plasma/applets/kimpanel/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="scim ibus"

RDEPEND="x11-libs/libX11
	x11-libs/libXpm
	x11-libs/libXrender
	x11-libs/libXt
	x11-libs/libXft"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_prepare() {
	echo -n '' > ${S}/backend/CMakeLists.txt
	
	if use scim ; then
		echo 'macro_optional_add_subdirectory(scim)' >> ${S}/backend/CMakeLists.txt
	fi
	
	# TODO: IBUS

	kde4-base_src_prepare
}

src_install() {
	kde4-base_src_install
	
	if use ibus ; then
		mkdir -p ${D}/usr/share/ibus/ui/qt
		mkdir -p ${D}/usr/share/ibus/component
		install -m755 ${S}/backend/ibus/panel.py ${D}/usr/share/ibus/ui/qt/
		install -m644 ${S}/backend/ibus/qtpanel.xml ${D}/usr/share/ibus/component/
	fi
}

pkg_postinst() {
	kde4-base_pkg_postinst
	elog "Please change ibus startup script:"
	elog "    ibus-daemon --panel=/usr/share/ibus/ui/qt/panel.py --xim"
	elog "and add plasmoid applet: Input Method Panel ."
}
