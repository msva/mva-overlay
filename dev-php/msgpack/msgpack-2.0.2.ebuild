# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PHP_EXT_NAME="${PN}"
USE_PHP="php5-6 php7-0 php7-1 php7-2"
DOCS=( README.md )
PHP_EXT_ECONF_ARGS=""

if [[ ${PV} == 9999 ]]; then
	VCS=git-r3
	PHP_ECL_PREF="source"
	EGIT_REPO_URI="https://github.com/${PN}/${PN}-php"
	KEYWORDS=""
else
	PHP_ECL_PREF="pecl"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

inherit php-ext-${PHP_ECL_PREF}-r3 ${VCS}

DESCRIPTION="API for communicating with MessagePack serialization"
HOMEPAGE="https://msgpack.org/"

LICENSE="BSD"
SLOT="0"
IUSE=""

DEPEND="dev-lang/php:*"
RDEPEND="${DEPEND}"

src_unpack() {
	[[ ${PV} == 9999 ]] && git-r3_src_unpack
	php-ext-source-r3_src_unpack
}
