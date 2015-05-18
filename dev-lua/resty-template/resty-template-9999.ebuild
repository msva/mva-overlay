# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from mva overlay; $

EAPI="5"

inherit base eutils toolchain-funcs git-r3

DESCRIPTION="Templating Engine (HTML) for Lua and OpenResty."
HOMEPAGE="https://github.com/bungle/lua-${PN}"
SRC_URI=""

EGIT_REPO_URI="https://github.com/bungle/lua-${PN}"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE="luajit"

RDEPEND="
	virtual/lua[luajit=]
	www-servers/nginx[nginx_modules_http_lua]
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

DOCS=( "README.md" )

src_install() {
	local lua=lua;
	use luajit && lua=luajit;

	insinto "$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD ${lua})"
	doins -r lib/resty

	base_src_install_docs
}
