# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

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

DEPEND="app-admin/eselect-luajit"

src_prepare(){
#	# probing for path to install jit libs
#	INST="$(pkg-config --variable INSTALL_LMOD lua)"
#	if [[ -z $INST ]]; then
#		sed -e "s|\(share/luajit\)-[^\"]*|\1-${PV}/|g" -i src/luaconf.h
#	else
#		sed -e "s|\(share/luajit\)-[^\"]*|${INST//\/usr\/}|g" -i src/luaconf.h
#		sed -e 's|INSTALL_JITLIB=.*|INSTALL_JITLIB= $(INSTALL_SHARE)/lua/$(ABIVER)/jit|g' -i Makefile
#	fi

	# fixing prefix and version
	sed -e 's|/usr/local|/usr|' \
		-e 's|/lib|/$(get_libdir)|' \
		-e 's|VERSION=.*|VERSION= ${PV}|' \
		-i Makefile || die "failed to fix prefix in Makefile"
	sed -e 's|\(share/luajit\)-[^"]*|\1-${PV}/|g'
		-e 's|/usr/local|/usr|' \
		-e 's|lib/|$(get_libdir)/|' \
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
