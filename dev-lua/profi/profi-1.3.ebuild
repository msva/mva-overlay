# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

GIST_A="perky"
GIST_ID="2838755"
GIST_SHA="78e573ca38b859c8639427c52d2c850736969bc7"

inherit lua

DESCRIPTION="a Lua Profiler"
HOMEPAGE="https://gist.github.com/perky/2838755"
SRC_URI="https://gist.github.com/${GIST_A}/${GIST_ID}/archive/${GIST_SHA}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~x86"
IUSE=""

LUA_S="${GIST_ID}-${GIST_SHA}"

each_lua_install() {
	dolua ProFi.lua
}
