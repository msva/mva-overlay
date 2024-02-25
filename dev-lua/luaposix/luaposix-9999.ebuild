# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua git-r3

DESCRIPTION="POSIX binding, including curses, for Lua 5.1 and 5.2"
HOMEPAGE="https://github.com/luaposix/luaposix"
EGIT_REPO_URI="https://github.com/luaposix/luaposix"

LICENSE="MIT"
SLOT="0"
IUSE="doc examples ncurses"

REQUIRED_USE="${LUA_REQUIRED_USE}"
RDEPEND="
	${LUA_DEPS}
	dev-lua/LuaBitOp[${LUA_USEDEP}]
	ncurses? ( sys-libs/ncurses:0 )
"
DEPEND="
	${RDEPEND}
	sys-kernel/linux-headers
	virtual/libc
	doc? ( dev-lua/ldoc )
"
#	dev-libs/gnulib
#	dev-lua/specl
#	dev-lua/lyaml

src_prepare() {
	default
	if use doc; then
		mkdir -p html
		sed \
			-e '/^dir/s@= ".*"@= "../html"@' \
			-e "s#@package@#${PN}#" \
			-e "s#@version@#git-${PF//${PN}-}#" \
			-i build-aux/config.ld.in || die
	fi
	sed -e '/^ldocs /d' -i lukefile || die

	lua_copy_sources
}

each_lua_compile() {
	pushd "${BUILD_DIR}"
	local mylukeargs=(
		package="${PN}"
		version="git-${PF//${PN}-}"
		PREFIX="/usr"
		LUA="${ELUA}"
		LUA_INCDIR="$(lua_get_include_dir)"
		CFLAGS="${CFLAGS} -fPIC"
		LIBFLAG="${LDFLAGS} -shared -fPIC"
	)
	"${ELUA}" build-aux/luke "${mylukeargs[@]}" || die
	rm lib/posix/version.lua.in || die
	popd
}

each_lua_install() {
	pushd "${BUILD_DIR}"
	insinto "$(lua_get_cmod_dir)"
	doins -r linux/posix
	insinto "$(lua_get_lmod_dir)"
	doins -r lib/posix
	popd
}

src_compile() {
	lua_foreach_impl each_lua_compile
	if use doc; then
		mv build-aux/config.ld.in build-aux/config.ld || die
		pushd "build-aux"
		ldoc . || die
		popd
	fi
}

src_install() {
	lua_foreach_impl each_lua_install
	if use doc; then
		HTML_DOCS+=(html/.)
	fi
	if use examples; then
		DOCS+=(doc/examples)
		docompress -x /usr/share/doc/"${PF}"/examples
	fi
	einstalldocs
}
