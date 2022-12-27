# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua mercurial

DESCRIPTION="Lua Asynchronous HTTP Library."
HOMEPAGE="https://code.matthewwild.co.uk/"
EHG_REPO_URI="https://code.matthewwild.co.uk/${PN}/"

LICENSE="MIT"
SLOT="0"
RESTRICT="network-sandbox"
REQUIRED_USE="${LUA_REQUIRED_USE}"
RDEPEND="
	${LUA_DEPS}
	dev-lua/luasocket
"
DEPEND="${RDEPEND}"
BDEPEND="dev-lua/squish"

src_prepare() {
	default
#		-e "s#net/httpclient#libs/httpclient#" \ #why it there?
	sed -r \
		-e 's#(AutoFetchURL ").*/prosody.im.*(/\?")#\1https://hg.prosody.im/0.8/raw-file/278489ee6e34\2#' \
		-i squishy || die
}

each_lua_compile() {
	squish --use-http || die
}

each_lua_install() {
	insinto "$(lua_get_lmod_dir)"
	doins lahttp.lua
}

src_compile() {
	lua_foreach_impl each_lua_compile
}

src_install() {
	lua_foreach_impl each_lua_install
	einstalldocs
}
