# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PHP_EXT_NAME="${PN%%-php}"
PHP_EXT_PECL_PKG="${PHP_EXT_NAME}"
USE_PHP="php7-4 php8-1"
DOCS=( README.md )

inherit php-ext-source-r3

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PHP_EXT_NAME}/${PN}"
else
	if [[ "${PV}" == *_rc* ]]; then
		PHP_EXT_PECL_A="${PHP_EXT_PECL_PKG}-${PV//_rc/RC}"
	else
		PHP_EXT_PECL_A="${PHP_EXT_PECL_PKG}-${PV//_/}"
	fi
	SRC_URI="https://pecl.php.net/get/${PHP_EXT_PECL_A}.tgz"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
	PHP_EXT_S="${WORKDIR}/${PHP_EXT_PECL_A}"
	S="${PHP_EXT_S}"
fi

DESCRIPTION="API for communicating with MessagePack serialization"
HOMEPAGE="https://msgpack.org/"

LICENSE="BSD"
SLOT="0"

DEPEND="dev-lang/php:*"
RDEPEND="${DEPEND}"
