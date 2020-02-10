# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools gnome2

DESCRIPTION="Backend implementation for xdg-desktop-portal that is using GTK Frameworks"
SRC_URI="https://github.com/flatpak/${PN}/archive/${PV}.tar.gz"
LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="screencast"

DEPEND="
	dev-libs/glib
	>=sys-apps/xdg-desktop-portal-${PV}[screencast?]
"
RDEPEND="${DEPEND}
"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myconf=(
		##--with-dbus-service-dir="${EPREFIX}"/etc/dbus-1/services
		##--with-systemduserunitdir="$(systemd_get_userunitdir)"
	)
	econf "${myconf[@]}"
}
