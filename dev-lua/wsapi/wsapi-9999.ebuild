# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua git-r3 toolchain-funcs

DESCRIPTION="Lua WSAPI Library"
HOMEPAGE="https://github.com/keplerproject/wsapi"
EGIT_REPO_URI="https://github.com/keplerproject/wsapi"

LICENSE="MIT"
SLOT="0"
IUSE="examples uwsgi fcgi"
#TODO: xavante"
RDEPEND="
	fcgi? (
		dev-libs/fcgi
		virtual/httpd-fastcgi
	)
	uwsgi? (
		www-servers/uwsgi
	)
	dev-lua/rings
	dev-lua/coxpcall
"
#TODO:	xavante? ( dev-lua/xavante )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

DOCS=(doc/us/{index,libraries,license,manual}.md)
HTML_DOCS=(doc/us/{index,libraries,license,manual}.html doc/us/doc.css doc/us/"${PN}".png)

src_prepare() {
	default
	sed -r \
		-e "s/\r//g" \
		-i src/launcher/wsapi{,.cgi,.fcgi}
	rm configure
	lua_copy_sources
}

each_lua_make() {
	pushd "${BUILD_DIR}"
	if use fcgi; then
		$(tc-getCC) ${CFLAGS} -fPIC ${LDFLAGS} -shared "-I$(lua_get_include_dir)" -o src/fastcgi/lfcgi.so src/fastcgi/lfcgi.c -lfcgi
	fi
	popd
}

each_lua_install() {
	pushd "${BUILD_DIR}"
	insinto "$(lua_get_lmod_dir)"
	doins -r src/*.lua src/"${PN}"
	if use fcgi; then
		insinto "$(lua_get_cmod_dir)"
		doins src/fastcgi/lfsgi.so
	fi
	newbin src/launcher/"${PN}".cgi "${PN}-${ELUA}".cgi
	use fcgi && newbin src/launcher/"${PN}".fcgi "${PN}-${ELUA}".fcgi
	popd
}

src_compile() {
	lua_foreach_impl each_lua_make
}

src_install() {
	lua_foreach_impl each_lua_install
	if use examples; then
		mv samples examples
		DOCS+=(examples)
		docompress -x /usr/share/doc/"${PF}"/examples
	fi
	einstalldocs
}
