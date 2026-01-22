# Copyright 2026 mva
# Distributed under the terms of the Public Domain or CC0 License

EAPI=8

inherit meson-multilib

DESCRIPTION="GIF encoder written in C"
HOMEPAGE="https://github.com/dloebl/cgif"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/dloebl/cgif"
else
	SRC_URI="https://github.com/dloebl/${PN}/archive/refs/tags/V${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

LICENSE="BSD"
SLOT="0"

RDEPEND="virtual/zlib"
