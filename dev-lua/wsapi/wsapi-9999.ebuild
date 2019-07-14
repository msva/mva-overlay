# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VCS="git"
GITHUB_A="keplerproject"
#IS_MULTILIB=true

inherit lua

DESCRIPTION="Lua WSAPI Library"
HOMEPAGE="https://github.com/keplerproject/wsapi"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc examples uwsgi fcgi"
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

DOCS=(doc/us/{index,libraries,license,manual}.md)
HTML_DOCS=(doc/us/{index,libraries,license,manual}.html doc/us/doc.css doc/us/${PN}.png)
EAMPLES=(samples/.)

all_lua_prepare() {
	sed -r \
		-e "s/\r//g" \
		-i src/launcher/wsapi{,.cgi,.fcgi}
	lua_default
	rm configure
}

#each_lua_configure() {
#	myeconfargs=(
#		LUA_DIR=$(lua_get_pkgvar INSTALL_LMOD)
#		LUA_LIBDIR=$(lua_get_pkgvar INSTALL_CMOD)
#		INC=-I$(lua_get_pkgvar includedir)
#	)
#	lua_default
#}

each_lua_install() {
	dolua src/*.lua src/${PN}
	newbin src/launcher/${PN}.cgi ${PN}-${TARGET}.cgi
	use fcgi && newbin src/launcher/${PN}.fcgi ${PN}-${TARGET}.fcgi
}
