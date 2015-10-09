# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit base eutils multilib-minimal git-r3

DESCRIPTION="A non-backtracking regex engine matching on data streams"
HOMEPAGE="https://github.com/openresty/sregex"
SRC_URI=""

EGIT_REPO_URI="https://github.com/openresty/sregex"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE=""

multilib_src_configure() {
	cd "${BUILD_DIR}"
	sed -r \
		-e "/^INSTALL_LIB/s/lib/$(get_libdir)/" \
		-i Makefile
}

multilib_src_compile() {
	cd "${BUILD_DIR}"
	base_src_compile PREFIX="/usr"
}

multilib_src_install() {
	cd "${BUILD_DIR}"
	base_src_install PREFIX="/usr"
}
