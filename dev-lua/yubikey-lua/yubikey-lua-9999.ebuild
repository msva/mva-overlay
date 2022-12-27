# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua mercurial

DESCRIPTION="Module for parsing and verifying Yubikey OTP tokens"
HOMEPAGE="https://code.matthewwild.co.uk/"
EHG_REPO_URI="https://code.matthewwild.co.uk/${PN}/"

LICENSE="MIT LGPL-2.1+"
SLOT="0"
REQUIRED_USE="${LUA_REQUIRED_USE}"
RDEPEND="
	${LUA_DEPS}
"
DEPEND="${RDEPEND}"
BDEPEND="dev-lua/squish"

src_prepare() {
	default
	lua_copy_sources
}

each_lua_compile() {
	pushd "${BUILD_DIR}"
	squish
	popd
}

each_lua_install() {
	pushd "${BUILD_DIR}"
	insinto "$(lua_get_lmod_dir)"
	doins yubikey.lua
	popd
}

src_compile() {
	lua_foreach_impl each_lua_compile
}

src_install() {
	lua_foreach_impl each_lua_install
	einstalldocs
}
