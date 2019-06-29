# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="The command line interface for WordPress"
HOMEPAGE="https://wp-cli.org/"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/v${PV}/${P}.phar"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE=""

DEPEND="dev-lang/php:*"
RDEPEND="${DEPEND}"

src_unpack() {
	mkdir -p "${S}"
	cp -L "${DISTDIR}/${A}" "${S}/${PN}"
}

src_install() {
	dobin "${PN}"
	dosym "${PN}" /usr/bin/wp
}
