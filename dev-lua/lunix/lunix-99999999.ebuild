# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua git-r3 toolchain-funcs

DESCRIPTION="Lua Unix Module"
HOMEPAGE="http://25thandclement.com/~william/projects/lunix.html"
EGIT_REPO_URI="https://github.com/wahern/lunix"

LICENSE="MIT"
SLOT="0"
IUSE="examples"
REQIUIRED_USE="${LUA_REQIUIRED_USE}"

DEPEND="
	${LUA_DEPS}
	dev-libs/openssl:*
"
RDEPEND="${DEPEND}"

src_prepare() {
	eerror "currently lunix is totally broken:"
	eerror "- doesn't build with default makefiles,"
	eerror "- miss many headers (compiler complains on implicit declarations and non-defined NL_TEXTMAX)"
	die "TODO: check someday if it is already fixed"
	default
	sed  -r \
		-e "s@(^prefix ).*@\1=/usr@" \
		-e "s@(^libdir .*prefix\)).*@\1/$(get_libdir)@" \
		-i GNUmakefile
	lua_copy_sources
}

each_lua_compile() {
	pushd "${BUILD_DIR}"

	$(tc-getCC) ${CFLAGS} ${LDFLAGS} -fPIC -shared src/*.c -o unix.so || die

	popd
}

each_lua_install() {
	pushd "${BUILD_DIR}"
	insinto "$(lua_get_lmod_dir)"
	doins unix.so
	popd
}

src_compile() {
	lua_foreach_impl each_lua_compile
}

src_install() {
	lua_foreach_impl each_lua_install
	if use examples; then
		DOCS+=(examples)
		docompress -x "/usr/share/doc/${PF}/examples"
	fi
	einstalldocs
}
