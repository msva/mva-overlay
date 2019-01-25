# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

VCS="git"
GITHUB_A="mah0x211"
MY_PN="${PN##lua-}"

inherit lua

DESCRIPTION="Lua bindings for dev-libs/xxhash (XXH32 only for now)"
HOMEPAGE="https://github.com/mah0x211/lua-xxhash"

LICENSE="MIT BSD-2"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="dev-libs/xxhash"
DEPEND="${RDEPEND}"

DOCS=(README.md)

each_lua_compile() {
	append-cflags "-I./src"
	${CC} ${CFLAGS} -c -o "${MY_PN}.o" "src/${MY_PN}.c"
	${CC} ${CFLAGS} -c -o "${MY_PN}_bind.o" "src/${MY_PN}_bind.c"
	${CC} ${LDFLAGS} -lxxhash -o "${MY_PN}".so "${MY_PN}.o" "${MY_PN}_bind.o"
}

each_lua_install() {
	dolua "${MY_PN}".so
}
