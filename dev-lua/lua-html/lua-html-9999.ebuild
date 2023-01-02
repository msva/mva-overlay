# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua git-r3 toolchain-funcs

DESCRIPTION="lua bindings for HTMLParser in libxml2"
HOMEPAGE="https://github.com/sprhawk/lua-html"
EGIT_REPO_URI="https://github.com/sprhawk/lua-html"

LICENSE="MIT"
SLOT="0"
REQUIRED_USE="${LUA_REQUIRED_USE}"
RDEPEND="
	${LUA_DEPS}
	dev-libs/libxml2
"
DEPEND="${RDEPEND}"

src_prepare() {
	default

	# macos thing in linux target
	sed -r \
		-e "s#-undefined dynamic_lookup##g" \
		-e '/^CC=/d' \
		-e '/^LDFLAGS=/d' \
		-i Makefile

	# Wrong case of header name
	sed -r \
		-e 's#libxml/HTMLParser.h#libxml/HTMLparser.h#' \
		-i html.c

	mv Readme.md README.md

	lua_copy_sources
}

each_lua_test() {
	pushd "${BUILD_DIR}"
	${ELUA} test.lua
	popd
}

each_lua_compile() {
	pushd "${BUILD_DIR}"
	myemakeargs=(
		CFLAGS="${CFLAGS} $($(tc-getPKG_CONFIG) --cflags-only-I libxml-2.0) -fPIC -c"
		LDFLAGS="${LDFLAGS} $($(tc-getPKG_CONFIG) --libs-only-L libxml-2.0) -fPIC"
		CC=$(tc-getCC)
		LD=$(tc-getLD)
	)
	emake "${myemakeargs[@]}"
	popd
}

each_lua_install() {
	pushd "${BUILD_DIR}"
	insinto "$(lua_get_cmod_dir)"
	doins html.so
	popd
}

src_test() {
	lua_foreach_impl each_lua_test
}

src_compile() {
	lua_foreach_impl each_lua_compile
}

src_install() {
	lua_foreach_impl each_lua_install
	einstalldocs
}
