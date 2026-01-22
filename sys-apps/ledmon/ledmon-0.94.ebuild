# Copyright 2026 mva
# Distributed under the terms of the Public Domain or CC0 License

EAPI=8

inherit autotools

DESCRIPTION="Enclosure LED Utilities"
HOMEPAGE="https://github.com/intel/ledmon"
SRC_URI="https://github.com/intel/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--enable-systemd
	)
	econf "${myeconfargs[@]}"
}
