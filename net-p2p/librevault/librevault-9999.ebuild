# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils cmake-utils git-r3

DESCRIPTION="Peer-to-peer, decentralized and open source file sync."
HOMEPAGE="https://librevault.com"

SRC_URI=""
EGIT_REPO_URI="https://github.com/${PN^}/${PN}"

LICENSE="GPL3"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
dev-db/sqlite
>=dev-libs/boost-1.58.0
>=dev-libs/crypto++-5.6.2
>=dev-libs/openssl-1.0.1
>=dev-libs/protobuf-3.0
dev-qt/qtcore
dev-qt/qtgui
dev-qt/qtnetwork
dev-qt/qtwebsockets
dev-qt/qtwidgets
net-libs/libnatpmp
net-libs/miniupnpc
|| (
	>=sys-devel/gcc-4.9
	>=sys-devel/clang-3.4
)
virtual/libc
"

RDEPEND="${DEPEND}"

DOCS=( README.md )
