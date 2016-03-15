# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit base eutils multilib-minimal

DESCRIPTION="A non-backtracking regex engine matching on data streams"
HOMEPAGE="https://github.com/openresty/sregex"
SRC_URI=""

SRC_URI="https://github.com/openresty/${PN}/archive/v${PV//_}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86 ~arm ~amd64"
IUSE=""

S="${WORKDIR}/${P//_}"

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
	base_src_compile PREFIX="/usr"
}

multilib_src_install() {
	cd "${BUILD_DIR}"
	base_src_install PREFIX="/usr"
}
