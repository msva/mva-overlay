# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VCS="git"
GITHUB_A="pavouk"
#IS_MULTILIB=1
# ^ gobject-introspection isn't multilib yet!
inherit lua

DESCRIPTION="Dynamic Lua binding to GObject libraries using GObject-Introspection"
HOMEPAGE="https://github.com/pavouk/lgi"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc examples test luajit"

# TODO: Lua 5.2 handling

DEPEND="
	${RDEPEND}
	dev-libs/glib
	dev-libs/gobject-introspection
	dev-libs/libffi
"

DOCS=( README.md docs )
EXAMPLES=( samples/. )

each_lua_test() {
	emake LUA="${lua_impl}" PKG_CONFIG="${PKG_CONFIG}" check
}

each_lua_install() {
	emake PREFIX="/usr" LUA_VERSION="$(lua_get_abi)" DESTDIR="${D}" install
}
