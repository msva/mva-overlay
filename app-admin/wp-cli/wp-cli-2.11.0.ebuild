# Copyright 2026 mva
# Distributed under the terms of the Public Domain or CC0 License

EAPI=8

DESCRIPTION="The command line interface for WordPress"
HOMEPAGE="https://wp-cli.org/"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/v${PV}/${P}.phar"

S="${WORKDIR}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

DEPEND="dev-lang/php:*"
RDEPEND="${DEPEND}"

src_install() {
	newbin "${DISTDIR}/${A}" wp
}
