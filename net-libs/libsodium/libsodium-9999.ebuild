# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit base eutils multilib-build git-2

DESCRIPTION="A portable fork of NaCl, a higher-level cryptographic library"
HOMEPAGE="https://github.com/jedisct1/libsodium"
SRC_URI=""

EGIT_REPO_URI="https://github.com/jedisct1/libsodium"
EGIT_BOOTSTRAP="./autogen.sh"

LICENSE="ISC"
SLOT="0"
KEYWORDS=""
IUSE="+asm +urandom"

src_prepare() {
	epatch_user
	multilib_copy_sources
}

sodium_src_configure() {
	cd "${BUILD_DIR}"

	econf \
			$(use_enable asm) \
			$(use_enable !urandom blocking-random)
}

sodium_src_compile() {
	cd "${BUILD_DIR}"
	base_src_compile
}

sodium_src_install() {
	cd "${BUILD_DIR}"
	base_src_install
}

src_configure() {
	multilib_parallel_foreach_abi sodium_src_configure
}

src_compile() {
	multilib_foreach_abi sodium_src_compile
}

src_install() {
	multilib_foreach_abi sodium_src_install
	multilib_check_headers
}
