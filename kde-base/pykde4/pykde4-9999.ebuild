# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

KMNAME="kdebindings"
KMMODULE="python/${PN}"
OPENGL_REQUIRED="always"
inherit python kde4-meta

DESCRIPTION="Python bindings for KDE4"
KEYWORDS=""
IUSE="akonadi debug semantic-desktop"

DEPEND="
	>=dev-python/PyQt4-4.4.4-r1[webkit]
	>=kde-base/kdelibs-${PV}:${SLOT}[opengl]
	akonadi? ( >=kde-base/kdepimlibs-${PV}:${SLOT} )
	semantic-desktop? (
		>=kde-base/kdelibs-${PV}:${SLOT}[semantic-desktop]
		>=kde-base/nepomuk-${PV}:${SLOT}
	)
"

src_prepare() {
	sed -i -e's/MACRO_OPTIONAL_FIND_PACKAGE(KdepimLibs)//'\
		python/${PN}/CMakeLists.txt\
	|| die "Failed to patch cmake files."

	kde4-meta_src_prepare
}

src_configure() {
	mycmakeargs="${mycmakeargs}
		-DWITH_QScintilla=OFF
		$(cmake-utils_use_with semantic-desktop Soprano)
		$(cmake-utils_use_with semantic-desktop Nepomuk)
		$(cmake-utils_use_with akonadi Akonadi)
		$(cmake-utils_use_with akonadi KdepimLibs)"

	kde4-meta_src_configure
}

src_install() {
	kde4-meta_src_install

	python_version
	rm -f "${D}/usr/$(get_libdir)/python${PYVER}"/site-packages/PyKDE4/*.py[co]
	rm -f "${D}${PREFIX}/share/apps/${PN}"/*.py[co]
}

pkg_postinst() {
	kde4-meta_pkg_postinst

	python_mod_optimize \
		"/usr/$(get_libdir)/python${PYVER}"/site-packages/PyKDE4 \
		"${PREFIX}/share/apps/${PN}"
}

pkg_postrm() {
	kde4-meta_pkg_postrm

	python_mod_cleanup
}
