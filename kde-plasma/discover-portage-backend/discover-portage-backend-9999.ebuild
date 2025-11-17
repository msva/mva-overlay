# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake git-r3

DESCRIPTION="Native Portage package manager backend for KDE Discover"
HOMEPAGE="https://github.com/keklick1337/discover-portage-backend"

EGIT_REPO_URI="https://github.com/keklick1337/discover-portage-backend.git"
EGIT_SUBMODULES=( '*' )

S="${WORKDIR}/${P}/src"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
PROPERTIES="live"

DEPEND="
	>=kde-frameworks/kcoreaddons-6.0.0:6
	>=kde-frameworks/ki18n-6.0.0:6
	>=kde-frameworks/kconfig-6.0.0:6
	>=kde-plasma/discover-6.4.5:6
	dev-qt/qtbase:6=[dbus,widgets]
	dev-build/cmake
"

RDEPEND="
	${DEPEND}
	app-eselect/eselect-repository
	app-portage/portage-utils
	app-portage/eix
	app-portage/gentoolkit
	sys-auth/polkit
"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr"
		-DKDE_INSTALL_USE_QT_SYS_PATHS=ON
		-DCMAKE_BUILD_TYPE=Release
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
}

src_install() {
	cmake_src_install

	# Ensure proper permissions for KAuth helper
	fperms 0755 /usr/libexec/kf6/kauth/portage_backend_helper || die
}

pkg_postinst() {
	elog "Note: This is early-stage software. Use with caution on production systems."
	elog ""
	elog "For more information, see:"
	elog "  https://github.com/keklick1337/discover-portage-backend"
}
