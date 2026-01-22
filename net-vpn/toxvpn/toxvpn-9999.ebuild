# Copyright 2026 mva
# Distributed under the terms of the Public Domain or CC0 License

EAPI=8

inherit cmake git-r3

DESCRIPTION="toxvpn allows one to make tunneled point to point connections over Tox"
HOMEPAGE="https://github.com/cleverca22/toxvpn"
EGIT_REPO_URI="https://github.com/cleverca22/toxvpn.git"

LICENSE="GPL-3"
SLOT="0"
IUSE="static systemd zeromq"

RDEPEND="
	net-libs/tox
	systemd? ( sys-apps/systemd )
	zeromq? ( net-libs/zeromq )
"
DEPEND="
	${RDEPEND}
	dev-cpp/nlohmann_json
"

src_configure() {
	local mycmakeargs=()
	use static && mycmakeargs+=(-DSTATIC=ON)
	use systemd && mycmakeargs+=(-DSYSTEMD=ON)
	use zeromq && mycmakeargs+=(-DZMQ=ON)
	cmake_src_configure
}
