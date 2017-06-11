# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
CMAKE_IN_SOURCE_BUILD="true"

inherit kde5 flag-o-matic

EGIT_REPO_URI="git://anongit.kde.org/ring-kde"
KEYWORDS=""

DESCRIPTION="KDE Ring client"
HOMEPAGE="https://projects.savoirfairelinux.com/projects/ring-kde-client/wiki"

LICENSE="GPL-3"

SLOT="0"

IUSE="akonadi doc +video"

RDEPEND="
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kcrash)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep kglobalaccel)
	$(add_frameworks_dep kguiaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kinit)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep knotifications)
	$(add_frameworks_dep knotifyconfig)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kwindowsystem)
	$(add_frameworks_dep kxmlgui)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtopengl)
	$(add_qt_dep qtprintsupport)
	$(add_qt_dep qtsvg)
	$(add_qt_dep qtwidgets)
	akonadi? ( $(add_kdeapps_dep akonadi) $(add_kdeapps_dep akonadi-contacts) $(add_kdeapps_dep kcontacts) )
	=net-libs/libringclient-${PV}[video?]
"

DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

	# temporary fix, until next branch will be merged
PATCHES=(
	"${FILESDIR}/cmake_fix.diff"
)

kde5_src_configure()  {
	local mycmakeargs=(
		-DENABLE_VIDEO="$(usex video true false)"
	)
	append-cxxflags "-I/usr/include/libringclient -I/usr/include/dring"
	cmake-utils_src_configure
}

kde5_src_install() {
	use doc && doxygen Doxyfile
	use doc && HTML_DOCS=( "${S}/html/" )
	use !doc && rm {AUTHORS,NEWS,README.md}
	cmake-utils_src_install
}
