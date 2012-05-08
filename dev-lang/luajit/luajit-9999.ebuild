# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from mva overlay $

EAPI="4"

inherit eutils multilib pax-utils git-2

DESCRIPTION="Just-In-Time Compiler for the Lua programming language"
HOMEPAGE="http://luajit.org/"
SRC_URI=""
EGIT_REPO_URI="http://luajit.org/git/luajit-2.0.git"

LICENSE="MIT"
SLOT="2"
KEYWORDS="~amd64 ~x86"
IUSE=""

CDEPEND="dev-lang/lua"
DEPEND="${CDEPEND}
	app-admin/eselect-luajit"

src_prepare(){
	# fixing prefix and version
	sed -e "s|/usr/local|/usr|" \
		-e "s|/lib|/$(get_libdir)|" \
		-e "s|VERSION=.*|VERSION= ${PV}|" \
		-i Makefile || die "failed to fix prefix in Makefile"

	sed -e "s|\(share/luajit\)-[^\"]*|\1-${PV}/|g" \
		-e "s|/usr/local|/usr|" \
		-e "s|lib/|$(get_libdir)/|" \
		-i src/luaconf.h || die "failed to fix prefix in luaconf.h"

	# removing strip
	sed -e '/$(Q)$(TARGET_STRIP)/d' -i src/Makefile \
		|| die "failed to remove forced strip"
}

src_install(){
	einstall DESTDIR="${D}"
	pax-mark m "${D}usr/bin/luajit-${PV}"
	dosym "luajit-${PV}" "/usr/bin/luajit-${SLOT}"
}

pkg_postinst() {
	ewarn "Now you should select LuaJIT version to use as system default LuaJIT interpreter."
	ewarn "Use 'eselect luajit list' to look for installed versions and"
	ewarn "Use 'eselect luajit set <NUMBER_or_NAME>' to set version you chose."
}
