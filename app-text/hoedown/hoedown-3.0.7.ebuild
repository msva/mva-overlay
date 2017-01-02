# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit multilib-minimal

DESCRIPTION="Standards compliant, fast, secure markdown processing library in C"

HOMEPAGE="https://github.com/hoedown/hoedown"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="
	dev-util/gperf
"
RDEPEND=""

src_prepare() {
	sed -r \
		-e '/^PREFIX/s@(=).*@\1/usr@' \
		-i Makefile

	default
	multilib_copy_sources
}
