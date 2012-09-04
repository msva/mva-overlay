# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="4"

#USE_PHP="php5-3 php5-4"
# currently not 5.4 compatible
PHP_EXT_NAME="dmtx"
PHP_EXT_ZENDEXT="yes"

inherit git-2 php-ext-source-r2 eutils

DESCRIPTION="PHP bindings for the dmtx library"
HOMEPAGE="https://github.com/mkoppanen/php-dmtx"
SRC_URI=""

EGIT_REPO_URI="https://github.com/mkoppanen/php-dmtx.git git://github.com/mkoppanen/php-dmtx.git"

LICENSE="PHP-3.01"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="dev-lang/php media-libs/libdmtx"
DEPEND="${RDEPEND}"

src_unpack() {
	git-2_src_unpack
	for slot in $(php_get_slots); do
		cp -r "${S}" "${WORKDIR}/${slot}"
	done
}

src_prepare() {
	epatch_user
	php-ext-source-r2_src_prepare
}