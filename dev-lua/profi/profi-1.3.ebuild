# Copyright 2026 mva
# Distributed under the terms of the Public Domain or CC0 License

EAPI=8

GIST_A="perky"
GIST_ID="2838755"
GIST_SHA="78e573ca38b859c8639427c52d2c850736969bc7"

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua

DESCRIPTION="a Lua Profiler"
HOMEPAGE="https://gist.github.com/perky/2838755"
SRC_URI="https://gist.github.com/${GIST_A}/${GIST_ID}/archive/${GIST_SHA}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/${GIST_ID}-${GIST_SHA}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~x86"
REQUIRED_USE="${LUA_REQUIRED_USE}"

RDEPEND="${LUA_DEPS}"
DEPEND="${RDEPEND}"

each_lua_install() {
	insinto "$(lua_get_lmod_dir)"
	doins ProFi.lua
}

src_install() {
	lua_foreach_impl each_lua_install
	einstalldocs
}
