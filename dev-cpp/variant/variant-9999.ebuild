# Copyright 2026 mva
# Distributed under the terms of the Public Domain or CC0 License

EAPI=8

inherit patches

DESCRIPTION="An header-only alternative to boost::variant for C++11 and C++14"
HOMEPAGE="https://github.com/mapbox/variant"

if [[ "${PV}" == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/mapbox/variant"
else
	SRC_URI="https://github.com/mapbox/variant/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~mips ~ppc64 ~riscv ~x86"
fi

LICENSE="BSD"
SLOT="0"

src_compile() { :; }
# ^ header-only. Makefile only builds tests

src_install() {
	insinto /usr/include/mapbox
	doins "${S}"/include/mapbox/*.hpp
}
