# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

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
	!luajit? ( >=dev-lang/lua-5.1 )
	luajit?  ( dev-lang/luajit:2 )
	www-servers/nginx[nginx_modules_http_lua]
"
DEPEND="
	${RDEPEND}
	dev-util/pkgconfig
"

DOCS=( "README.md" )

src_install() {
	local lua=lua;
	use luajit && lua=luajit;

	insinto "$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD ${lua})"
	doins -r lib/resty

	base_src_install_docs
}
