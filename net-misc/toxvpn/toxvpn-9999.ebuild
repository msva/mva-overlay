# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils eutils git-r3

DESCRIPTION="toxvpn allows one to make tunneled point to point connections over Tox"
HOMEPAGE="https://github.com/cleverca22/toxvpn"
EGIT_REPO_URI="https://github.com/cleverca22/toxvpn.git"

LICENSE="GPL-3"
SLOT="0"

RDEPEND="
	net-libs/tox
"
DEPEND="
	${RDEPEND}
	dev-libs/nlohmann-json
"

src_prepare() {
	cmake-utils_src_prepare

	# https://github.com/cleverca22/toxvpn/issues/15
	# https://github.com/cleverca22/toxvpn/pull/16
	sed -r 's@^(#include <)(json.hpp>)$@\1nlohmann/\2@' \
	-i src/main.h
}
