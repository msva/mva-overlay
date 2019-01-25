# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

GITHUB_A="starwing"

inherit lua

DESCRIPTION="lightweight, native, lazy evaluating multithreading library"
HOMEPAGE="https://github.com/starwing/luautf8"

SRC_URI="
	https://github.com/${GITHUB_A}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	https://unicode.org/Public/UCD/latest/ucd/UCD.zip
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~x86"
IUSE="examples"

DOCS=(README.md)
EXAMPLES=(test{,_{compat,pm}}.lua)

src_unpack() {
	local ucd="${WORKDIR}/all/${P}/ucd";
	lua_src_unpack
	mkdir "${ucd}"
	mv "${WORKDIR}"/all/*.txt "${ucd}"
}

all_lua_prepare() {
	lua_default
	lua parseucd.lua
}

each_lua_compile() {
	${CC} ${CFLAGS} ${LDFLAGS} lutf8lib.c -o lua-utf8.so
}

each_lua_install() {
	dolua lua-utf8.so
}
