# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

VCS="git"
GITHUB_A="bungle"
GITHUB_PN="lua-${PN}"

inherit lua-broken

DESCRIPTION="Templating Engine (HTML) for Lua and OpenResty."
HOMEPAGE="https://github.com/bungle/lua-resty-template"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	www-servers/nginx:*[nginx_modules_http_lua]
"
DEPEND="
	${RDEPEND}
"

DOCS=(README.md)

each_lua_install() {
	dolua lib/resty
}
