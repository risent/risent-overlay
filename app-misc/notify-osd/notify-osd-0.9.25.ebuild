# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Canonical's on-screen-display notification agent"
HOMEPAGE="https://launchpad.net/notify-osd"
#SRC_URI="http://launchpad.net/${PN}/${PV%.*}/${PV}/+download/${P}.tar.gz"
#SRC_URI="http://launchpad.net/${PN}/trunk/ubuntu-9.10/+download/${P}.tar.gz"
SRC_URI="http://launchpad.net/${PN}/trunk/ubuntu-9.10-sru/+download/${P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples mono"

RDEPEND=">=dev-libs/glib-2.16
	>=dev-libs/dbus-glib-0.76
	>=gnome-base/gconf-2
	>=x11-libs/gtk+-2.14
	>=x11-libs/libnotify-0.4.5
	x11-libs/libwnck
	!x11-misc/notification-daemon
	!x11-misc/notification-daemon-xfce
	!x11-misc/xfce4-notifyd"
DEPEND="${RDEPEND}
	examples? ( mono? ( dev-dotnet/notify-sharp ) )
	>=dev-util/pkgconfig-0.9"

RESTRICT="test"

src_compile() {
	local myconf

	if use examples ; then
		if use mono ; then
			myconf="${myconf} --with-examples=all"
		else
			myconf="${myconf} --with-examples=c"
		fi
	else
		myconf="${myconf} --without-examples"
	fi
	econf ${myconf} || die
	emake || die
}

src_install() {
	emake DESTDIR="${D}" install || die

	dodoc AUTHORS ChangeLog NEWS README TODO
}
