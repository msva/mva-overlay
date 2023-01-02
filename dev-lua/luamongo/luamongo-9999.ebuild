# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua git-r3

DESCRIPTION="Lua driver for MongoDB"
HOMEPAGE="https://github.com/moai/luamongo"
EGIT_REPO_URI="https://github.com/moai/luamongo"

LICENSE="MIT"
SLOT="0"
IUSE="doc examples"
REQUIRED_USE="${LUA_REQUIRED_USE}"

RDEPEND="
	${LUA_DEPS}
	dev-libs/boost
	dev-libs/mongo-cxx-driver
"
#	dev-db/mongodb[sharedclient]
# NB: Incompatible with current mongo-driver

DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

pkg_pretend() {
	die "Not working anymore. Use dev-lua/lua-mongo or dev-lua/resty-mongol"
}

src_prepare() {
	default
	sed \
		-e 's@libmongo-client@libmongocxx@g' \
		-i Makefile

#		-e "/client\/init.h/d" \
	sed \
		-e "s@client/dbclient.h@mongocxx/client.hpp@" \
		-e "/client\/init.h/d" \
		-i main.cpp mongo_bsontypes.cpp mongo_dbclient.cpp

	lua_copy_sources
}

each_lua_compile() {
	pushd "${BUILD_DIR}"
	emake LUAPKG="${ELUA}" "${PN}"
	popd
}

each_lua_install() {
	pushd "${BUILD_DIR}"
	insinto "$(lua_get_cmod_dir)"
	doins mongo.so
	popd
}

src_compile() {
	lua_foreach_impl each_lua_compile
}

src_install() {
	lua_foreach_impl each_lua_install
	if use examples; then
		mv tests examples
		DOCS+=(examples)
		docompress -x /usr/share/doc/"${PF}"/examples
	fi
	einstalldocs
}
