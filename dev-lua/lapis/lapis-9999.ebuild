# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua git-r3

DESCRIPTION="A web framework for Lua/MoonScript."
HOMEPAGE="https://github.com/leafo/lapis"
EGIT_REPO_URI="https://github.com/leafo/lapis"

LICENSE="MIT"
SLOT="0"
IUSE="moonscript"
REQUIRED_USE="${LUA_REQUIRED_USE}"
RDEPEND="
	${LUA_DEPS}
	moonscript? ( dev-lua/moonscript )
	dev-lua/ansicolors[${LUA_USEDEP}]
	dev-lua/luasocket[${LUA_USEDEP}]
	dev-lua/luacrypto[${LUA_USEDEP}]
	dev-lua/lua-cjson[${LUA_USEDEP}]
	dev-lua/lpeg[${LUA_USEDEP}]
	dev-lua/lua-rds-parser[${LUA_USEDEP}]
	dev-lua/resty-upload[${LUA_USEDEP}]
"
DEPEND="
	${RDEPEND}
"

DOCS=( docs/. README.md )

src_prepare() {
	use moonscript || find "${S}" -type -name '*.moon' -delete
	default
	lua_copy_sources
}

each_lua_compile() {
	pushd "${BUILD_DIR}"
	use moonscript && emake build
	popd
}

each_lua_install() {
	pushd "${BUILD_DIR}"
	insinto "$(lua_get_lmod_dir)"
	use moonscript && doins lapis.moon
	doins -r lapis
	popd
}

src_compile() {
	lua_foreach_impl each_lua_compile
}

src_install() {
	lua_foreach_impl each_lua_install
	dobin bin/lapis
	einstalldocs
}
