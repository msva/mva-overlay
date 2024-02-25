# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua mercurial

DESCRIPTION="XMPP client library written in Lua."
HOMEPAGE="https://code.matthewwild.co.uk/"
EHG_REPO_URI="https://code.matthewwild.co.uk/${PN}/"
RESTRICT="network-sandbox"
# ^ :(
# fetches depends from prosody's trunk during build

LICENSE="MIT"
SLOT="0"
IUSE="examples"
REQUIRED_USE="${LUA_REQUIRED_USE}"

RDEPEND="
	${LUA_DEPS}
	dev-lua/luasocket[${LUA_USEDEP}]
	dev-lua/luaexpat[${LUA_USEDEP}]
	dev-lua/luafilesystem[${LUA_USEDEP}]
	dev-lua/LuaBitOp[${LUA_USEDEP}]
"
DEPEND="${RDEPEND}"
BDEPEND="dev-lua/squish"

#src_unpack() {
#	mercurial_src_unpack
#	default
#}

src_prepare() {
	default
	sed -r \
		-e "s@^(PREFIX)=.*@\1=/usr@" \
		-e "s@^(LUA_VERSION)=.*@\1=${ELUA##lua}@" \
		-e '/\*\)/,/esac/{/echo/d;/exit 1/d}' \
		-i configure
	lua_copy_sources
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
