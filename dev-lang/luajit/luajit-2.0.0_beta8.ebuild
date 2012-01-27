# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit eutils multilib pax-utils

MY_P="LuaJIT-${PV/_/-}"

DESCRIPTION="Just-In-Time Compiler for the Lua programming language"
HOMEPAGE="http://luajit.org/"
SRC_URI="http://luajit.org/download/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="2"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-admin/eselect-luajit"
S="${WORKDIR}/${MY_P}"

src_prepare(){
	# fixing prefix and version
	sed -i -e "s|/usr/local|/usr|" \
		-e "s|/lib|/$(get_libdir)|" \
		-e "s|VERSION=.*|VERSION= ${PV}|" \
		Makefile || die "failed to fix prefix in Makefile"
	sed -i -e 's|/usr/local|/usr|' \
		-e "s|lib/|$(get_libdir)/|" \
		src/luaconf.h || die "failed to fix prefix in luaconf.h"

	# removing strip
	sed -i -e '/$(Q)$(TARGET_STRIP)/d' src/Makefile \
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