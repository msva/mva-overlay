# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
#LUA_COMPAT="lua51 lua52 lua53 luajit2"
inherit lua

DESCRIPTION="A tool for linting and static analysis of Lua code"
HOMEPAGE="https://github.com/mpeterv/luacheck"
SRC_URI="https://github.com/mpeterv/luacheck/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~x86"
IUSE="doc test"

RDEPEND="
	dev-lua/luafilesystem
	dev-lua/lanes
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( dev-python/sphinx )
	test? (
		dev-lua/busted
		dev-lua/luautf8
	)"

DOCS=( CHANGELOG.md README.md )

all_lua_compile() {
	if use doc; then
		sphinx-build docsrc html || die
	fi
}

each_lua_test() {
	busted -o gtest || die
}

each_lua_install() {
	dolua src/luacheck
}
all_lua_install() {
	newbin bin/luacheck.lua luacheck
	use doc && HTML_DOCS+=( html/. )
	einstalldocs
}
