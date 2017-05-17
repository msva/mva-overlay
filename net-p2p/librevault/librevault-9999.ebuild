# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils cmake-utils git-r3

DESCRIPTION="Peer-to-peer, decentralized and open source file sync."
HOMEPAGE="https://librevault.com"

SRC_URI=""
EGIT_REPO_URI="https://github.com/${PN^}/${PN}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="cli daemon debug gui static static-libs"

REQUIRED_USE="|| ( cli daemon gui ) static? ( static-libs )"

DEPEND="
	gui? (
		dev-qt/qtcore:5[static-libs(+)=]
		dev-qt/qtgui:5[static-libs(+)=]
		dev-qt/qtnetwork:5[static-libs(+)=]
		dev-qt/qtwebsockets:5[static-libs(+)=]
		dev-qt/qtwidgets:5[static-libs(+)=]
	)
	daemon? (
		dev-db/sqlite:3[static-libs(+)=]
		net-libs/libnatpmp[static-libs(+)=]
		net-libs/miniupnpc[static-libs(+)=]
		dev-libs/jsoncpp[static-libs(+)=]
		dev-cpp/websocketpp[static-libs(+)=]
	)
	>=dev-libs/boost-1.58.0[static-libs(+)=]
	>=dev-libs/crypto++-5.6.2[static-libs(+)=]
	>=dev-libs/openssl-1.0.1[static-libs(+)=]
	>=dev-libs/protobuf-3.0[static-libs(+)=]
	|| (
		>=sys-devel/gcc-4.9:*
		>=sys-devel/clang-3.4:*
	)
	virtual/libc
"

RDEPEND="${DEPEND}"

DOCS=( Readme.md )

src_configure() {
	 local mycmakeargs=(
		-DBUILD_CLI=$(usex cli ON OFF)
		-DBUILD_GUI=$(usex gui ON OFF)
		-DBUILD_DAEMON=$(usex daemon ON OFF)
		-DBUILD_STATIC=$(usex static ON OFF)
		-DBUILD_UPDATER=OFF
		-DUSE_BUNDLED_SQLITE3=OFF
		-DUSE_BUNDLED_MINIUPNP=OFF
		-DINSTALL_BUNDLE=OFF
		-DDEBUG_NORMALIZATION=$(usex debug ON OFF)
		-DDEBUG_WEBSOCKETPP=$(usex debug ON OFF)
		-DDEBUG_QT=$(usex debug ON OFF)
	)
	cmake-utils_src_configure
}
