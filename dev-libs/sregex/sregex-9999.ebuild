# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

inherit eutils multilib-minimal git-r3

DESCRIPTION="A non-backtracking regex engine matching on data streams"
HOMEPAGE="https://github.com/openresty/sregex"
SRC_URI=""

EGIT_REPO_URI="https://github.com/openresty/sregex"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE=""

src_prepare() {
	multilib_copy_sources
}

multilib_src_configure() {
	cd "${BUILD_DIR}"
	sed -r \
		-e "/^INSTALL_LIB/s/lib/$(get_libdir)/" \
		-i Makefile
}

multilib_src_compile() {
	cd "${BUILD_DIR}"
	emake PREFIX="/usr"
}

multilib_src_install() {
	cd "${BUILD_DIR}"
	einstall PREFIX="/usr"
}
