# Copyright 2026 mva
# Distributed under the terms of the Public Domain or CC0 License

EAPI=8

inherit autotools

DESCRIPTION="Phone Simulator for modem testing (oFono)"
HOMEPAGE="https://git.kernel.org/pub/scm/network/ofono/ofono.git"

if [[ "${PF}" = *_p* ]]; then
	MY_SHA="" # FILL-ME
	SRC_URI="https://git.kernel.org/pub/scm/network/ofono/${PN}.git/snapshot/${PN}-${MY_SHA}.tar.gz"
	S="${WORKDIR}/${PN}-${MY_SHA}"
else
	SRC_URI="https://mirrors.edge.kernel.org/pub/linux/network/ofono/${P}.tar.xz"
fi

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

RDEPEND="net-misc/ofono"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default
	eautoreconf
}
