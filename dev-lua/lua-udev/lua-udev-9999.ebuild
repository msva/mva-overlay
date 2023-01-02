# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua git-r3 toolchain-funcs

DESCRIPTION="udev bindings for Lua"
HOMEPAGE="https://github.com/dodo/lua-udev/"
EGIT_REPO_URI="https://github.com/dodo/lua-udev/"

LICENSE="MIT"
SLOT="0"
IUSE="examples"

REQUIRED_USE="${LUA_REQUIRED_USE}"

DEPEND="
	${LUA_DEPS}
	virtual/libudev
"

src_prepare() {
	default
	if use lua_targets_luajit; then
		sed -i -r \
			-e '/LUA_VERSION_NUM/s@(503)@\1 \&\& !defined(luaL_newlib)@' \
			"${PN}".c || die
	fi
	lua_copy_sources
}

each_lua_compile() {
	pushd "${BUILD_DIR}"
	$(tc-getCC) "${PN}.c" ${CFLAGS} ${LDFLAGS} -fPIC -shared -ludev -o udev.so || die "Unable to compile"
	popd
}

src_compile() {
	lua_foreach_impl each_lua_compile
}

each_lua_install() {
	pushd "${BUILD_DIR}"
	insinto "$(lua_get_cmod_dir)"
	doins udev.so
	popd
}

src_install() {
	lua_foreach_impl each_lua_install
	if use examples; then
		DOCS+=(test.lua)
	fi
	einstalldocs
}
