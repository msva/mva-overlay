# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="The command line interface for WordPress"
HOMEPAGE="https://wp-cli.org/"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/v${PV}/${P}.phar"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

DEPEND="dev-lang/php:*"
RDEPEND="${DEPEND}"

S="${WORKDIR}"

src_install() {
	newbin "${DISTDIR}/${A}" wp
}
