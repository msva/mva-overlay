# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua mercurial

DESCRIPTION="XMPP client library written in Lua."
HOMEPAGE="https://code.matthewwild.co.uk/"
EHG_REPO_URI="https://code.matthewwild.co.uk/${PN}/"

LICENSE="MIT"
SLOT="0"
IUSE="examples"
REQUIRED_USE="${LUA_REQUIRED_USE}"
RESTRICT="network-sandbox"
# ^ :(
# fetches depends from prosody's trunk during build

RDEPEND="
	${LUA_DEPS}
	dev-lua/luasocket[${LUA_USEDEP}]
	dev-lua/luaexpat[${LUA_USEDEP}]
	dev-lua/luafilesystem[${LUA_USEDEP}]
	dev-lua/LuaBitOp[${LUA_USEDEP}]
"
DEPEND="${RDEPEND}"
# BDEPEND="dev-lua/squish"

src_prepare() {
	default
	sed -r \
		-e "s@^(PREFIX)=.*@\1=/usr@" \
		-e '/\*\)/,/esac/{/echo/d;/exit 1/d}' \
		-i configure || die
	lua_copy_sources
	lua_foreach_impl each_lua_prepare
}

each_lua_prepare() {
	pushd "${BUILD_DIR}"
	sed -r \
		-e "s@^(LUA_VERSION)\=.*@\1=${ELUA##lua}@" \
		-e "s@^(LUA_INTERPRETER)\=.*@\1=${ELUA}@" \
		-e "/^PROSODY_URL/s@0\.10@trunk@" \
		-i ./configure || die
	sed -r \
		-e "1s@/lua[^/]*\$@/${ELUA}@" \
		-i ./buildscripts/squish || die
	popd
}

each_lua_configure() {
	pushd "${BUILD_DIR}"
	default
	popd
}

each_lua_compile() {
	pushd "${BUILD_DIR}"
	default
	popd
}

each_lua_install() {
	pushd "${BUILD_DIR}"
	insinto "$(lua_get_lmod_dir)"
	doins "${PN}".lua
	popd
}

src_configure() {
	lua_foreach_impl each_lua_configure
}

src_compile() {
	lua_foreach_impl each_lua_compile
}

src_install() {
	lua_foreach_impl each_lua_install
	if use examples; then
		mv doc examples
		DOCS+=(examples)
		docompress -x "/usr/share/doc/${PF}/examples"
	fi
	einstalldocs
}
