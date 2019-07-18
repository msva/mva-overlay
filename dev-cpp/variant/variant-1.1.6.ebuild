# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit patches

DESCRIPTION="An header-only alternative to boost::variant for C++11 and C++14"
HOMEPAGE="https://github.com/mapbox/variant"

if [[ "${PV}" == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/mapbox/variant"
	KEYWORDS=""
else
	SRC_URI="https://github.com/mapbox/variant/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~mips ~x86"
fi

LICENSE="BSD"
SLOT="0"

DEPEND=""

src_compile() { :; }
# ^ header-only. Makefile only builds tests

src_install() {
	insinto /usr/include/mapbox
	doins "${S}"/include/mapbox/*.hpp
}
