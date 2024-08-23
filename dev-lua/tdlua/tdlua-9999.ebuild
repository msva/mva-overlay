# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua{5-{2..4},jit} )

inherit cmake lua git-r3

DESCRIPTION="A basic interface between tdlib and lua"
HOMEPAGE="https://github.com/giuseppeM99/tdlua"
EGIT_REPO_URI="https://github.com/giuseppeM99/tdlua"

EGIT_SUBMODULES=(
	"*"
	-td
)

LICENSE="GPL-3"
SLOT="0"
IUSE="examples static-libs +system-tdlib system-libtgvoip voip"
REQUIRED_USE="${LUA_REQUIRED_USE}"

RDEPEND="
	${LUA_DEPS}
	dev-libs/openssl:0=
	media-libs/opus:0=
	system-libtgvoip? ( media-libs/libtgvoip:= )
	system-tdlib? ( net-libs/tdlib:= )
	lua_targets_luajit? ( dev-lang/luajit[lua52compat] )
"
DEPEND="${RDEPEND}"

src_unpack() {
	if use system-libtgvoip || ! use voip; then
		EGIT_SUBMODULES+=(-libtgvoip)
	fi
	git-r3_src_unpack
}

src_prepare() {
	if use system-tdlib; then
		sed -i -r \
			-e '/add_subdirectory\(td\)/s@.*@find_package\(Td REQUIRED\)@' \
			CMakeLists.txt
	fi
	if use system-libtgvoip; then
		sed -i -r \
			-e 's@libtgvoip/@tgvoip/@' \
			LuaTDVoip.h LuaTDVoip.cpp
		sed -i -r \
			-e '/set\(TARGET\ "libtgvoip"\)/,/set_property\ \(TARGET\ libtgvoip\ PROPERTY\ CXX_STANDARD\ 11\)/d' \
			CMakeLists.txt
	fi
	cmake_src_prepare
	lua_copy_sources
}

each_lua_configure() {
	pushd "${BUILD_DIR}"
	mycmakeargs=(
		-DLUA_INCLUDE_DIR=$(lua_get_include_dir)
		-DTDLUA_TD_STATIC=$(usex static-libs ON OFF)
		-DTDLUA_CALLS=$(usex voip ON OFF)
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
	insinto "$(lua_get_cmod_dir)"
	doins "${PN}".so
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
	if use examples; then
		DOCS+=(examples)
		docompress -x "/usr/share/doc/${PF}/examples"
	fi
	einstalldocs
}
