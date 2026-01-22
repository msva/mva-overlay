# Copyright 2026 mva
# Distributed under the terms of the Public Domain or CC0 License

EAPI=8

inherit autotools git-r3

DESCRIPTION="Tools for reading and writing Data Matrix barcodes"
HOMEPAGE="https://github.com/dmtx/dmtx-utils/"
EGIT_REPO_URI="https://github.com/dmtx/${PN}"

LICENSE="LGPL-2.1"
SLOT="0"

RDEPEND="
	>=media-gfx/imagemagick-6.2.4
	>=media-libs/libdmtx-0.7.0
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default
	eautoreconf
}
