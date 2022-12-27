# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 autotools
# multilib-minimal

# libyubikey still non-multilib

DESCRIPTION="YubiKey Personalization cross-platform library and tool"
HOMEPAGE="https://github.com/Yubico/yubikey-personalization"
EGIT_REPO_URI="https://github.com/Yubico/yubikey-personalization.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="sys-auth/libyubikey"
RDEPEND="${DEPEND}"

PATCHES="${FILESDIR}/yubikey-ar.patch"

src_prepare() {
	default
	eautoreconf
#	multilib_copy_sources
}

#multilib_
src_configure() {
	econf --disable-static || die "Failed"
}
