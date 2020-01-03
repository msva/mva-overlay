# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Dependency Manager for PHP"
HOMEPAGE="https://getcomposer.org/"
SRC_URI="https://getcomposer.org/download/${PV/_alpha/-alpha}/composer.phar -> ${P}.phar"

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
}
