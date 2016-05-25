# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils multilib-minimal git-r3

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

multilib_src_configure() {
	cd "${BUILD_DIR}"

	econf \
			$(use_enable asm) \
			$(use_enable !urandom blocking-random)
}

multilib_src_compile() {
	cd "${BUILD_DIR}"
	default
}

multilib_src_install() {
	cd "${BUILD_DIR}"
	default
}
