# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VCS=hg
EVCS_URI="http://hg.neoscientists.org/tekui"
inherit lua

MY_P="${P//_p/-r}"

DESCRIPTION="TekUI is a small, freestanding and portable GUI toolkit written in Lua and C"
HOMEPAGE="http://tekui.neoscientists.org"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="+gradient +cache +fileno +png udp"

RDEPEND="
	$(lua_implementations_depend)
	media-libs/libpng:0
	media-libs/freetype
	media-libs/fontconfig
	x11-libs/libXft
	x11-libs/libX11
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

LUA_S="${MY_P}"

all_lua_prepare() {
	lua_default
	sed -r \
		-e '/^CC =/d' \
		-e 's@`pkg-config@`${PKG_CONFIG}@' \
		-e '/^(LUAVER ).*/s@@\1 = __LUA_ABI_PH__@' \
		-e '/^(LUA_LIB ).*/s@@\1 = $(DESTDIR)__LUA_LIB_PH__@' \
		-e '/^(LUA_SHARE ).*/s@@\1 = $(DESTDIR)__LUA_SHARE_PH__@' \
		-e '/^(TEKLIB_DEFS ).*/s@@\1 = __TEKLIB_DEFS_PH__@' \
		-e '/^(TEKUI_DEFS ).*/s@@\1 = __TEKUI_DEFS_PH__@' \
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
}

each_lua_configure() {
	lua_default
	local teklib_defs=() tekui_defs=() tekui_libs=()

	use gradient && tekui_defs+=('-DENABLE_GRADIENT')
	use cache && tekui_defs+=('-DENABLE_PIXMAP_CACHE')
	use fileno && tekui_defs+=('-DENABLE_FILENO')

	if use png; then
		tekui_defs+=( '-DENABLE_PNG' '$(PNG_DEFS)' )
		tekui_libs+=('$(PNG_LIBS)')
	fi

	teklib_defs+=('-DENABLE_LAZY_SINGLETON')

	sed -r \
		-e "s@__LUA_ABI_PH__@$(lua_get_abi)@" \
		-e "s@__LUA_LIB_PH__@$(lua_get_cmoddir)@" \
		-e "s@__LUA_SHARE_PH__@$(lua_get_lmoddir)@" \
		-e "s@__TEKLIB_DEFS_PH__@${teklib_defs[*]}@" \
		-e "s@__TEKUI_DEFS_PH__@${tekui_defs[*]}@" \
		-e "s@__TEKUI_LIBS_PH__@${tekui_libs[*]}@" \
	-i config
}
