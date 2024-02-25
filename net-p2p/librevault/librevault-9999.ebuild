# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake patches git-r3

DESCRIPTION="Peer-to-peer, decentralized and open source file sync."
HOMEPAGE="https://librevault.com"

EGIT_REPO_URI="https://github.com/${PN^}/${PN}"

LICENSE="GPL-3"
SLOT="0"
IUSE="cli daemon debug gui static"

REQUIRED_USE="|| ( cli daemon gui )"

DEPEND="
	gui? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtnetwork:5
		dev-qt/qtwebsockets:5
		dev-qt/qtwidgets:5
	)
	!static? (
		net-libs/libnatpmp
		net-libs/miniupnpc
		dev-db/sqlite:3
		dev-cpp/websocketpp
		dev-python/docopt
	)
	static? (
		dev-libs/boost[static-libs(+)]
	)
	>=dev-libs/boost-1.58.0
	>=dev-libs/crypto++-5.6.2
	>=dev-libs/openssl-1.0.1:0
	>=dev-libs/protobuf-3.0
	|| (
		>=sys-devel/gcc-4.9:*
		>=sys-devel/clang-3.4:*
	)
	virtual/libc
"
#		dev-libs/spdlog
# ^ Brakes builds with all gentoo versions

RDEPEND="${DEPEND}"

DOCS=( Readme.md )

src_prepare() {
	patches_src_prepare

	sed -r \
		-e 's@^(if\()(spdlog_FOUND)(\))@\11\22\3@' \
		-i CMakeLists.txt

	# ^ force fail to found system spdlog installation.
	# (never builds successfully against all versions gentoo have)
	# Well, actually, as of 2017/10/23 it is broken anyway.
	# see https://github.com/Librevault/librevault/issues/93
}

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
	cmake_src_configure
}
