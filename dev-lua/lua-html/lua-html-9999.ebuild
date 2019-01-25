# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

LUA_COMPAT="lua52"
VCS="git"
IS_MULTILIB=true
GITHUB_A="sprhawk"

inherit lua

DESCRIPTION="lua bindings for HTMLParser in libxml2"
HOMEPAGE="https://github.com/sprhawk/lua-html"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	${DEPEND}
	dev-libs/libxml2
"

DOCS=(README.md)

all_lua_prepare() {
	lua_default

	# macos thing in linux target
	sed -r \
		-e "s#-undefined dynamic_lookup##g" \
		-i Makefile

	# Wrong case of header name
	sed -r \
		-e 's#libxml/HTMLParser.h#libxml/HTMLparser.h#' \
		-i html.c

	mv Readme.md README.md
}

each_lua_test() {
	${LUA} test.lua
}

each_lua_configure() {
	myeconfargs=()
	myeconfargs+=(
		'CFLAGS+=$(shell $(PKG_CONFIG) --cflags-only-I libxml-2.0)'
		'LDFLAGS+=$(shell $(PKG_CONFIG) --libs-only-L libxml-2.0)'
	)
	lua_default
}

each_lua_install() {
	dolua html.so
}
