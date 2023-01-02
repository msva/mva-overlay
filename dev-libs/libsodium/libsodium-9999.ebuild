# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools multilib-minimal git-r3

DESCRIPTION="A portable fork of NaCl, a higher-level cryptographic library"
HOMEPAGE="https://github.com/jedisct1/libsodium"

EGIT_REPO_URI="https://github.com/jedisct1/libsodium"
EGIT_BRANCH="stable"

LICENSE="ISC"
SLOT="0/23"
IUSE="+asm minimal static-libs +urandom cpu_flags_x86_sse4_1 cpu_flags_x86_aes"

PATCHES=( "${FILESDIR}"/${PN}-1.0.10-cpuflags.patch )

src_prepare() {
	default
	eautoreconf
	multilib_copy_sources
}

multilib_src_configure() {
	local myconf

	[[ ${MULTIBUILD_VARIANT} =~ abi_x86_x?32 ]] &&
		myconf="${myconf} --disable-pie"

	econf \
		$(use_enable asm) \
		$(use_enable minimal) \
		$(use_enable !urandom blocking-random) \
		$(use_enable static-libs static) \
		$(use_enable cpu_flags_x86_sse4_1 sse4_1) \
		$(use_enable cpu_flags_x86_aes aesni) \
		${myconf}
}

multilib_src_install_all() {
	einstalldocs
	find "${D}" -name '*.la' -delete || die
}
