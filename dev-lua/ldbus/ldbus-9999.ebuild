# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

IS_MULTILIB=true
VCS="git"
GITHUB_A="daurnimator"

inherit lua

DESCRIPTION="A Lua library to access dbus"
HOMEPAGE="https://github.com/daurnimator/ldbus/"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc examples"

DOCS=(README.md)
EXAMPLES=(example.lua)

RDEPEND="
	sys-apps/dbus
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

all_lua_prepare() {
	cp "${FILESDIR}/GNUmakefile" "${S}/"
	sed -r \
		-e '1iinclude ../.lua_eclass_config' \
		-e 's@lua5.3@$(LUA_IMPL)@' \
		-e '/^PKG_CONFIG/d' \
		-e '/^LUA_LIBDIR/d' \
		-e '/install:/,${s@(\$\(LUA_LIBDIR\))@$(DESTDIR)/\1@g}' \
		-i src/Makefile
	lua_default
}

each_lua_install() {
	dolua src/{message,"${PN}".so}
}
