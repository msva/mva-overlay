# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib-minimal patches

DESCRIPTION="Standards compliant, fast, secure markdown processing library in C"

HOMEPAGE="https://github.com/hoedown/hoedown"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-util/gperf
"
RDEPEND=""

src_prepare() {
	patches_src_prepare
	sed -r \
		-e '/^PREFIX/s@(=).*@\1/usr@' \
		-e "/^LIBDIR/s@/lib\$@/$(get_libdir)@" \
		-i Makefile
	multilib_copy_sources
}
