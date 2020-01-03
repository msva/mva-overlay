# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils eutils git-r3

DESCRIPTION="toxvpn allows one to make tunneled point to point connections over Tox"
HOMEPAGE="https://github.com/cleverca22/toxvpn"
EGIT_REPO_URI="https://github.com/cleverca22/toxvpn.git"

IUSE="static systemd zeromq"
LICENSE="GPL-3"
SLOT="0"

RDEPEND="
	net-libs/tox
	systemd? ( sys-apps/systemd )
	zeromq? ( net-libs/zeromq )
"
DEPEND="
	${RDEPEND}
	dev-libs/nlohmann-json
"

src_configure() {
	local mycmakeargs=()
	use static && mycmakeargs+=(-DSTATIC=ON)
	use systemd && mycmakeargs+=(-DSYSTEMD=ON)
	use zeromq && mycmakeargs+=(-DZMQ=ON)
	cmake-utils_src_configure
}
