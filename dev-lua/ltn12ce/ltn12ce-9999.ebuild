# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VCS="git"
GITHUB_A="mkottman"
IS_MULTILIB=true

inherit cmake-utils lua

DESCRIPTION="LuaSocket's LTN12-compatible Crypto/Compressing Engine"
HOMEPAGE="https://github.com/mkottman/ltn12ce"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="+system-bzip +system-lzma +system-zlib"
# +system-polarssl
RDEPEND="
	system-bzip? ( app-arch/bzip2[$MULTILIB_USEDEP] )
	system-lzma? ( app-arch/xz-utils[$MULTILIB_USEDEP] )
	system-zlib? ( sys-libs/zlib[$MULTILIB_USEDEP] )
"
#	system-polarssl? ( net-libs/polarssl[$MULTILIB_USEDEP] )

DEPEND="
	${RDEPEND}
"

DOCS=(README.md)

all_lua_prepare() {
#	for d in {bzip,lzma,polarssl,zlib}; do
#		use "system-${d}" &&
#		sed -e "/add_subdirectory.*${d}/d" -i src/CMakeLists.txt
#		sed -e "/include_directories.*${d}/d" -i CMakeLists.txt
#	done
#	use system-lzma && sed -e "/include_directories ( include )/d" -i CMakeLists.txt
	lua_default
}

each_lua_configure() {
	mycmakeargs=(
		-DINSTALL_CMOD="$(lua_get_pkgvar INSTALL_CMOD)"
	)
	cmake-utils_src_configure
}
