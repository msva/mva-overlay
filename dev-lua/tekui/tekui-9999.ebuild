# Copyright 2026 mva
# Distributed under the terms of the Public Domain or CC0 License

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua toolchain-funcs

MY_P="${P//_p/-r}"

DESCRIPTION="TekUI is a small, freestanding and portable GUI toolkit written in Lua and C"
HOMEPAGE="http://tekui.neoscientists.org"

if [[ "${PV}" == 9999 ]]; then
	inherit mercurial
	EHG_REPO_URI="http://hg.neoscientists.org/tekui"
else
	SRC_URI="http://tekui.neoscientists.org/releases/${MY_P}.tgz"
	KEYWORDS="~amd64 ~arm ~arm64 ~mips ~x86"
	S="${WORKDIR}/${MY_P}"
fi

LICENSE="MIT"
SLOT="0"
IUSE="+gradient +cache +fileno +png udp"
REQUIRED_USE="${LUA_REQUIRED_USE}"

RDEPEND="
	${LUA_DEPS}
	media-libs/libpng:0
	media-libs/freetype
	media-libs/fontconfig
	x11-libs/libXft
	x11-libs/libX11
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	${LUA_DEPS}
	virtual/pkgconfig
"

src_prepare() {
	default
	sed -r \
		-e "/^CC =/s@(CC =).*@\1 $(tc-getCC) -fPIC@" \
		-e 's@`pkg-config@`${PKG_CONFIG}@' \
		-e '/^(LUAVER ).*/s@@\1 = __LUA_ABI_PH__@' \
		-e '/^(LUA_LIB ).*/s@@\1 = $(DESTDIR)__LUA_LIB_PH__@' \
		-e '/^(LUA_SHARE ).*/s@@\1 = $(DESTDIR)__LUA_SHARE_PH__@' \
		-e '/^(TEKLIB_DEFS ).*/s@@\1 = __TEKLIB_DEFS_PH__ -fPIC@' \
		-e '/^(TEKUI_DEFS ).*/s@@\1 = __TEKUI_DEFS_PH__ -fPIC@' \
		-e '/^(TEKUI_LIBS ).*/s@@\1 = __TEKUI_LIBS_PH__@' \
		-e '/^(PREFIX ).*/s@@\1 = $(DESTDIR)usr@' \
		-e '/^(INSTALL_S ).*/s@@\1 = $(INSTALL_B)@' \
		-e '/^(SYS_LUA_LIB ).*/s@@\1 = $(LUA_LIB)@' \
		-e '/^(SYS_LUA_SHARE ).*/s@@\1 = $(LUA_SHARE)@' \
		-e '/default-help:/ihijack-first-target-definition: all' \
		-e '/^PNG_DIR =/,+2d' \
		-e '/^TEKUI_DEFS/iPNG_LIBS = $(${PKG_CONFIG} --libs libpng)' \
		-e '/^TEKUI_DEFS/iPNG_DEFS = $(${PKG_CONFIG} --cflags libpng)' \
		-e '/^(FREETYPE_LIBS ).*/s@@\1= $(${PKG_CONFIG} --libs freetype2)@' \
		-e '/^(FREETYPE_DEFS ).*/s@@\1 = $(${PKG_CONFIG} --cflags freetype2)@' \
		-e '/^(X11_LIBS ).*/s@@\1 = $(${PKG_CONFIG} --libs x11)@' \
		-e '/^(X11_DEFS ).*/s@@\1 = $(${PKG_CONFIG} --cflags x11)@' \
		-e '/^(XFT_LIBS ).*/s@@\1 = $(${PKG_CONFIG} --libs xft)@' \
		-e '/^(XFT_DEFS ).*/s@@\1 = $(${PKG_CONFIG} --cflags xft)@' \
		-e '/^(FONTCONFIG_LIBS ).*/s@@\1 = $(${PKG_CONFIG} --libs fontconfig)@' \
		-e '/^(FONTCONFIG_DEFS ).*/s@@\1 = $(${PKG_CONFIG} --cflags fontconfig)@' \
	-i config
	lua_copy_sources
}

each_lua_configure() {
	pushd "${BUILD_DIR}"
	default
	local teklib_defs=() tekui_defs=() tekui_libs=()

	use gradient && tekui_defs+=('-DENABLE_GRADIENT')
	use cache && tekui_defs+=('-DENABLE_PIXMAP_CACHE')
	use fileno && tekui_defs+=('-DENABLE_FILENO')

	if use png; then
		tekui_defs+=( '-DENABLE_PNG' '$(PNG_DEFS)' )
		tekui_libs+=('$(PNG_LIBS)')
	fi

	teklib_defs+=('-DENABLE_LAZY_SINGLETON')

	if [[ ${ELUA} != luajit ]]; then
		LUA_VERSION="$(ver_cut 1-2 $(lua_get_version))"
	else
		# This is a workaround for luajit, as it confirms to lua5.1
		# and the 'GNUmakefile' doesn't understand LuaJITs version.
		LUA_VERSION="5.1"
	fi

	sed -r \
		-e "s@__LUA_ABI_PH__@${LUA_VERSION}@" \
		-e "s@__LUA_LIB_PH__@$(lua_get_cmod_dir)@" \
		-e "s@__LUA_SHARE_PH__@$(lua_get_lmod_dir)@" \
		-e "s@__TEKLIB_DEFS_PH__@${teklib_defs[*]}@" \
		-e "s@__TEKUI_DEFS_PH__@${tekui_defs[*]}@" \
		-e "s@__TEKUI_LIBS_PH__@${tekui_libs[*]}@" \
	-i config
	popd
}

src_configure() {
	lua_foreach_impl each_lua_configure
}

each_lua_compile() {
	pushd "${BUILD_DIR}"
	emake -j1 # broken build system
	popd
}
src_compile() {
	lua_foreach_impl each_lua_compile
}

each_lua_install() {
	pushd "${BUILD_DIR}"
	default
	popd
}
src_install() {
	lua_foreach_impl each_lua_install
}
