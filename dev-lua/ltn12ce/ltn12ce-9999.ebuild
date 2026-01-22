# Copyright 2026 mva
# Distributed under the terms of the Public Domain or CC0 License

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua git-r3 cmake

DESCRIPTION="LuaSocket's LTN12-compatible Crypto/Compressing Engine"
HOMEPAGE="https://github.com/mkottman/ltn12ce"
EGIT_REPO_URI="https://github.com/mkottman/ltn12ce"

LICENSE="MIT"
SLOT="0"
IUSE="+system-bzip +system-lzma +system-zlib"
# +system-polarssl
REQUIRED_USE="${LUA_REQUIRED_USE}"
RDEPEND="
	${LUA_DEPS}
	system-bzip? ( app-arch/bzip2 )
	system-lzma? ( app-arch/xz-utils )
	system-zlib? ( virtual/zlib )
"
#	system-polarssl? ( net-libs/polarssl )

DEPEND="
	${RDEPEND}
"

src_prepare() {
	cmake_src_prepare
	sed \
		-e '/target_link_libraries/{s@${LUA_LIBRARY}@@}' \
		-i cmake/lua.cmake || die
	#for d in {bzip,lzma,polarssl,zlib}; do
	for d in {bzip,lzma,zlib}; do
		if use "system-${d}"; then
			sed \
				-e "/add_subdirectory.*${d}/d" \
				-e "/DBUILD_${d^^}.*/d" \
				-e "/APPEND LIBRARIES/s@bzip2@bz2@" \
				-e "/APPEND LIBRARIES/s@zlib@z@" \
				-i src/CMakeLists.txt || die
			sed \
				-e "/include_directories.*${d}/d" \
				-i CMakeLists.txt || die
		fi
	done
#	use system-lzma && sed -e "/include_directories ( include )/d" -i CMakeLists.txt
	lua_copy_sources
}

each_lua_configure() {
	pushd "${BUILD_DIR}"
	mycmakeargs=(
		-DINSTALL_CMOD="$(lua_get_cmod_dir)"
	)
	cmake_src_configure
	popd
}

each_lua_compile() {
	pushd "${BUILD_DIR}"
	cmake_src_compile
	popd
}

each_lua_install() {
	pushd "${BUILD_DIR}"
	cmake_src_install
	popd
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
}
