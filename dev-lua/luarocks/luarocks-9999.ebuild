# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua git-r3

DESCRIPTION="A deployment and management system for Lua modules"
HOMEPAGE="https://www.luarocks.org"
EGIT_REPO_URI="https://github.com/luarocks/luarocks"

LICENSE="MIT"
SLOT="0"
IUSE="test"
RESTRICT="test"
REQUIRED_USE="${LUA_REQUIRED_USE}"

# TODO: eselect-luarocks?
RDEPEND="
	${LUA_DEPS}
	net-misc/curl
	dev-libs/openssl:0
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	virtual/pkgconfig
	test? (
		dev-lua/busted[${LUA_USEDEP}]
		dev-lua/busted-htest[${LUA_USEDEP}]
		${RDEPEND}
	)
"

src_prepare() {
	default
	# 1) Don't die on gentoo's econf calls!
	# 2) If 'dev-lang/lua' is a new, fresh installation, no 'LUA_LIBDIR' exists,
	# as no compiled modules are installed on a new, fresh installation,
	# so this check must be disabled, otherwise 'configure' will fail.
	sed -r \
		-e "/die.*Unknown flag:/d" \
		-e '/LUA_LIBDIR is not a valid directory/d' \
		-i configure || die

	lua_copy_sources
}

each_lua_test() {
	pushd "${BUILD_DIR}"
	busted --lua=${ELUA} || die
	popd
}

each_lua_configure() {
	pushd "${BUILD_DIR}"
	local myeconfargs=(
		--with-lua-lib="$(lua_get_cmod_dir)"
		--rocks-tree="$(lua_get_lmod_dir)"
		--with-lua-interpreter="${ELUA}"
		--with-lua-include="$(lua_get_include_dir)"
	)
	econf "${myeconfargs[@]}"
	popd
}

each_lua_compile() {
	pushd "${BUILD_DIR}"
	emake build
	popd
}

each_lua_install() {
	pushd "${BUILD_DIR}"
	default
	for l in luarocks{,-admin}; do
		mv "${D}/usr/bin/${l}" "${D}/usr/bin/${l}-${ELUA}"
	done
	keepdir /usr/"$(get_libdir)"/lua/luarocks/lib/luarocks/rocks-"${ELUA}"
	popd
}

src_test() {
	lua_foreach_impl each_lua_test
}

src_configure() {
	lua_foreach_impl each_lua_configure
}

src_compile() {
	lua_foreach_impl each_lua_compile
}

src_install() {
	lua_foreach_impl each_lua_install
	einstalldocs
	find "${D}" -type f -exec sed -e "s:${D}::g" -i {} ";" || die "sedding out D from installation image failed"
}
