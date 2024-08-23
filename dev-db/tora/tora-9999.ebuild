# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake desktop

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://github.com/tora-tool/tora"
	inherit git-r3
else
	SRC_URI="https://github.com/tora-tool/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
fi

DESCRIPTION="TOra - Toolkit For Oracle"
HOMEPAGE="https://torasql.com/"

LICENSE="GPL-2"
SLOT="0"
IUSE="debug mysql oracle oci8-instant-client postgres +experimental"

RDEPEND="
	dev-libs/ferrisloki
	x11-libs/qscintilla:=
	dev-qt/qtcore:5=
	dev-qt/qtgui:5=
	dev-qt/qtnetwork:5=
	dev-qt/qtprintsupport:5=
	dev-qt/qtsql:5=[mysql?,postgres?]
	dev-qt/qtwidgets:5=
	dev-qt/qtxml:5=
	dev-qt/qtxmlpatterns:5=
	oci8-instant-client? ( dev-db/oracle-instantclient )
	postgres? ( dev-db/postgresql:* )
"
DEPEND="
	dev-qt/linguist-tools:5
	virtual/pkgconfig
	${RDEPEND}
"

pkg_setup() {
	if ( use oracle || use oci8-instant-client ) && [ -z "$ORACLE_HOME" ] ; then
		eerror "ORACLE_HOME variable is not set."
		eerror
		eerror "You must install Oracle >= 8i client for Linux in"
		eerror "order to compile TOra with Oracle support."
		eerror
		eerror "Otherwise disable oracle support in your USE variable."
		eerror
		eerror "You can download the Oracle software from"
		eerror "http://otn.oracle.com/software/content.html"
		die
	fi
}

src_prepare() {
	sed -i \
		-e "/COPYING/ d" \
		CMakeLists.txt
#		-e 's@-ggdb3@-ggdb3 -fPIC@' \

#	# Getoo QScintilla package not installing static library,
#	# but upstream cmake module looking for only it, but not shared.
#	sed -ri \
#		-e '/FIND_LIBRARY/s@(libqscintilla2).a@\1.so@' \
#		cmake/modules/FindQScintilla.cmake

	# bug 547520
	grep -rlZ '$$ORIGIN' . | xargs -0 sed -i 's|:$$ORIGIN[^:"]*||' || \
		die 'Removal of $$ORIGIN failed'

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=()
	if use oracle || use oci8-instant-client ; then
		mycmakeargs=(-DENABLE_ORACLE=ON)
	else
		mycmakeargs=(-DENABLE_ORACLE=OFF)
	fi
	mycmakeargs+=(
		-DWANT_RPM=OFF
		-DWANT_INTERNAL_QSCINTILLA=OFF
		-DWANT_INTERNAL_LOKI=OFF
		-DLOKI_LIBRARY="$(pkg-config --variable=libdir ferrisloki)/libferrisloki.so"
		-DLOKI_INCLUDE_DIR="$(pkg-config --variable=includedir ferrisloki)/FerrisLoki"
		-DENABLE_PGSQL=$(usex postgres)
		-DQT5_BUILD=ON
		-DUSE_EXPERIMENTAL=$(usex experimental)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	doicon src/icons/${PN}.xpm
	domenu src/${PN}.desktop
}
