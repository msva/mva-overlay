# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit})
MY_P="${PN}-rel-${PV}"

inherit lua toolchain-funcs git-r3

DESCRIPTION="Most comprehensive OpenSSL module in the Lua universe"
HOMEPAGE="https://github.com/wahern/luaossl"
EGIT_REPO_URI="https://github.com/wahern/luaossl/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="examples"
REQUIRED_USE="${LUA_REQUIRED_USE}"

RDEPEND="
	dev-libs/openssl:0=[-bindist(-)]
	!dev-lua/lua-openssl
	${LUA_DEPS}
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

DOCS=( "doc/." )

src_prepare() {
	default

	# Remove Lua autodetection
	# Respect users CFLAGS
	sed -e '/LUAPATH :=/d' -e '/LUAPATH_FN =/d' -e '/HAVE_API_FN =/d' -e '/WITH_API_FN/d' -e 's/-O2//g' -i GNUmakefile || die

	lua_copy_sources
}

lua_src_compile() {
	pushd "${BUILD_DIR}" || die

	if [[ ${ELUA} != luajit ]]; then
		LUA_VERSION="$(ver_cut 1-2 $(lua_get_version))"
	else
		# This is a workaround for luajit, as it confirms to lua5.1
		# and the 'GNUmakefile' doesn't understand LuaJITs version.
		LUA_VERSION="5.1"
	fi

	local myemakeargs=(
		"CC=$(tc-getCC)"
		"ALL_CPPFLAGS=${CPPFLAGS} $(lua_get_CFLAGS)"
		"libdir="
	)

	emake "${myemakeargs[@]}" openssl${LUA_VERSION}

	popd
}

src_compile() {
	lua_foreach_impl lua_src_compile
}

lua_src_install() {
	pushd "${BUILD_DIR}" || die

	if [[ ${ELUA} != luajit ]]; then
		LUA_VERSION="$(ver_cut 1-2 $(lua_get_version))"
	else
		# This is a workaround for luajit, as it confirms to lua5.1
		# and the 'GNUmakefile' doesn't understand LuaJITs version.
		LUA_VERSION="5.1"
	fi

	local myemakeargs=(
		"DESTDIR=${D}"
		"lua${LUA_VERSION/./}cpath=$(lua_get_cmod_dir)"
		"lua${LUA_VERSION/./}path=$(lua_get_lmod_dir)"
		"prefix=${EPREFIX}/usr"
	)

	emake "${myemakeargs[@]}" install${LUA_VERSION}

	popd
}

src_install() {
	lua_foreach_impl lua_src_install

	if use examples; then
		DOCS+=(examples)
		docompress -x "${EROOT}/usr/share/doc/${PF}/examples"
	fi
	einstalldocs
}
