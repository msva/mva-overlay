# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VCS="git"
GITHUB_A="bungle"
GITHUB_PN="lua-${PN}"

inherit lua

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
