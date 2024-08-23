# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Free and simple TrueCrypt Implementation based on dm-crypt"
HOMEPAGE="https://github.com/bwalex/tc-play"
SRC_URI="https://github.com/bwalex/tc-play/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}"/${P}

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs test"

# Tests need root privileges, access to /dev/loop0 and mostly fail
RESTRICT="test"

RDEPEND="
	dev-libs/libgpg-error
	>=dev-libs/libgcrypt-1.5.0:0
	sys-apps/util-linux
	sys-fs/lvm2
"
DEPEND=" ${RDEPEND}"

# without some kernel modules, this isn't going to work
CONFIG_CHECK="~CRYPTO_RMD160 ~CRYPTO_SHA512 ~CRYPTO_WP512 ~CRYPTO_LRW
~CRYPTO_XTS ~CRYPTO_AES ~CRYPTO_SERPENT ~CRYPTO_TWOFISH ~DM_CRYPT ~BLK_DEV_LOOP"
WARNING_CRYPTO_RMD160="CRYPTO_RMD160 required to use RIPEMD-160 encryption"
WARNING_CRYPTO_SHA512="CRYPTO_SHA512 required to use SHA encryption"
WARNING_CRYPTO_AES="CRYPTO_AES required to use AES encryption"
WARNING_CRYPTO_SERPENT="CRYPTO_SERPENT required to use Serpent encryption"
WARNING_CRYPTO_TWOFISH="CRYPTO_TWOFISH required to use Twofish encryption"
WARNING_DM_CRYPT="DM_CRYPT is required for ${PN} to work!"
WARNING_BLK_DEV_LOOP="BLK_DEV_LOOP is required to mount encrypted volumes in
files"

DOCS=( README.md )

src_install() {
	cmake_src_install
	use static-libs || find "${D}" -name lib${PN}.a -delete
}

src_test() {
	cp -R ../${P}_build/* . || die
	cd test || die
	cucumber features
}
