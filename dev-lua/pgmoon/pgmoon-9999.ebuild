# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua git-r3

DESCRIPTION="A pure Lua Postgres driver for use in OpenResty & more"
HOMEPAGE="https://github.com/Kong/pgmoon"
EGIT_REPO_URI="https://github.com/Kong/pgmoon"

if [[ "${PV}" != 9999 ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~x86 ~amd64-linux ~x86-linux"
	# ppc ppc64 riscv
	# ^ nginx
	EGIT_COMMIT="v${PV}"
fi

IUSE="moonscript openresty"

LICENSE="MIT"
SLOT="0"
REQUIRED_USE="${LUA_REQUIRED_USE} openresty? ( lua_targets_luajit )"
DEPEND="
	${LUA_DEPS}
"
RDEPEND="
	${DEPEND}
	moonscript? ( dev-lua/moonscript )
	!openresty? (
		dev-lua/luasec[${LUA_USEDEP}]
		dev-lua/luasocket[${LUA_USEDEP}]
		dev-lua/luaossl[${LUA_USEDEP}]
	)
	openresty? (
		dev-lua/resty-openssl[lua_targets_luajit]
		>=www-servers/nginx-1.24.0-r10[nginx_modules_http_lua,ssl,lua_single_target_luajit]
		dev-lua/penlight[${LUA_USEDEP}]
	)
	lua_targets_lua5-1? ( dev-lua/LuaBitOp[${LUA_USEDEP}] )
	|| ( dev-lua/lpeg[${LUA_USEDEP}] dev-lua/lulpeg[lpeg_replace(-),${LUA_USEDEP}] )
	dev-lua/lua-cjson
"

DOCS=(README.md)

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
	# use moonscript && doins pgmoon.moon
	doins -r pgmoon
	# pgmoon.lua
	popd
}

src_compile() {
	lua_foreach_impl each_lua_compile
}

src_install() {
	lua_foreach_impl each_lua_install
	einstalldocs
}
