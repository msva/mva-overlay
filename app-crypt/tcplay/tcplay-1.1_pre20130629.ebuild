# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

USE_RUBY="ruby19"

inherit ruby-ng eutils vcs-snapshot cmake-utils

COMMIT_ID="b44b1fad854c726dda3ec7bfc96fe2d437d4343f"
DESCRIPTION="Free and simple TrueCrypt Implementation based on dm-crypt"
HOMEPAGE="https://github.com/bwalex/tc-play"
SRC_URI="https://github.com/bwalex/tc-play/tarball/${COMMIT_ID} -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="static-libs test"
S="${WORKDIR}"/${P}

# Tests need root privileges, access to /dev/loop0 and mostly fail
RESTRICT="test"

RDEPEND+=" dev-libs/libgpg-error
	>=dev-libs/libgcrypt-1.5.0
	sys-apps/util-linux
	sys-fs/lvm2"
DEPEND+=" ${RDEPEND}"

ruby_add_bdepend "test? ( dev-ruby/json
		dev-util/cucumber
		dev-ruby/rspec
		dev-ruby/ffi )"

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
	cmake-utils_src_install
	use static-libs || find "${D}" -name lib${PN}.a -delete
}

src_test() {
	cp -R ../${P}_build/* . || die
	cd test || die
	cucumber features
}
