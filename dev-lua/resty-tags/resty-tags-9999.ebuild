# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VCS="git"
GITHUB_A="bungle"
GITHUB_PN="lua-${PN}"

inherit lua

DESCRIPTION="A small DSL for building HTML documents"
HOMEPAGE="https://github.com/bungle/lua-resty-tags"

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
