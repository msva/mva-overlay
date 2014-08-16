# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit base eutils multilib-build git-r3

DESCRIPTION="A non-backtracking regex engine matching on data streams"
HOMEPAGE="https://github.com/openresty/sregex"
SRC_URI=""

EGIT_REPO_URI="https://github.com/openresty/sregex"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE=""

src_prepare() {
	epatch_user
	multilib_copy_sources
}


sregex_src_configure() {
	cd "${BUILD_DIR}"
	sed -r \
		-e "/^INSTALL_LIB/s/lib/$(get_libdir)/" \
		-i Makefile
}

src_configure() {
	multilib_parallel_foreach_abi sregex_src_configure
}


sregex_src_compile() {
	cd "${BUILD_DIR}"
	base_src_compile PREFIX="/usr"
}

sregex_src_install() {
	cd "${BUILD_DIR}"
	base_src_install PREFIX="/usr"
}

src_compile() {
	multilib_foreach_abi sregex_src_compile
}

src_install() {
	multilib_foreach_abi sregex_src_install
	multilib_check_headers
}
