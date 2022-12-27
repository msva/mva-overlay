# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua mercurial toolchain-funcs

DESCRIPTION="LuaJIT FFI bindings to net-dns/unbound"
HOMEPAGE="https://code.zash.se/luaunbound"
EHG_REPO_URI="https://code.zash.se/luaunbound"

LICENSE="MIT"
SLOT="0"
REQUIRED_USE="${LUA_REQUIRED_USE}"
RDEPEND="
	${LUA_DEPS}
	net-dns/unbound
"
DEPEND="${RDEPEND}"

DOCS=( README.markdown )

src_prepare() {
	default
	sed -r \
		-e "/^LUA_VERSION/d" \
		-e "/^LUA_PC/d" \
		-e "/^LUA_LIBDIR/d" \
		-e "/^CFLAGS/s@-ggdb@@" \
		-i GNUmakefile
	lua_copy_sources
}

each_lua_compile() {
	pushd "${BUILD_DIR}" || die
	emake LD="$(tc-getCC)" LUA_PC="${ELUA}" || die
	popd
}

each_lua_install() {
	pushd "${BUILD_DIR}" || die
	emake DESTDIR="${D}" LUA_LIBDIR="$(lua_get_cmod_dir)" install || die
	popd
}

src_compile() {
	lua_foreach_impl each_lua_compile
}

src_install() {
	lua_foreach_impl each_lua_install
	einstalldocs
}
