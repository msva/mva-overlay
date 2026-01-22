# Copyright 2026 mva
# Distributed under the terms of the Public Domain or CC0 License

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua git-r3

DESCRIPTION="Lua binding to media-libs/libharu (PDF generator)"
HOMEPAGE="https://github.com/jung-kurt/luahpdf"
EGIT_REPO_URI="https://github.com/jung-kurt/luahpdf"

LICENSE="MIT"
SLOT="0"
IUSE="doc examples"

REQUIRED_USE="${LUA_REQUIRED_USE}"

RDEPEND="
	${LUA_DEPS}
	media-libs/libharu
"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	sed -i -r \
		-e 's#(_COMPILE=)cc#\1$(CC)#' \
		-e 's#(_LINK=)cc#\1$(CC)#' \
		-e 's#(_REPORT=).*#\1#' \
		Makefile
	sed -i -r \
		-e "/include[^a-z]*hpdf.h/i#include \<hpdf_version.h\>\n" \
		hpdf.c
	lua_copy_sources
}

each_lua_compile() {
	pushd "${BUILD_DIR}"
	emake LUAINC="$(lua_get_CFLAGS)"
	popd
}

src_compile() {
	lua_foreach_impl each_lua_compile
}

each_lua_install() {
	pushd "${BUILD_DIR}"
	insinto "$(lua_get_cmod_dir)"
	doins hpdf.so
	popd
}

src_install() {
	lua_foreach_impl each_lua_install
	if use doc; then
		DOCS+=(doc/.)
	fi
	if use examples; then
		mv demo examples
		DOCS+=(examples)
		docompress -x /usr/share/doc/${PF}/examples
	fi
	einstalldocs
}
